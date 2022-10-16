{ config, pkgs, lib, ... }: {

  imports = [ ./caddy.nix ./secrets.nix ./backups.nix ];

  options = {

    nextcloudServer = lib.mkOption {
      type = lib.types.str;
      description = "Hostname for Nextcloud";
    };

  };

  config = {

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud24; # Required to specify
      https = true;
      hostName = "localhost";
      maxUploadSize = "50G";
      config = {
        adminpassFile = config.secrets.nextcloud.dest;
        extraTrustedDomains = [ config.nextcloudServer ];
      };
    };

    # Don't let Nginx use main ports (using Caddy instead)
    services.nginx.virtualHosts."localhost".listen = [{
      addr = "127.0.0.1";
      port = 8080;
    }];

    # Point Caddy to Nginx
    caddyRoutes = [{
      match = [{ host = [ config.nextcloudServer ]; }];
      handle = [{
        handler = "reverse_proxy";
        upstreams = [{ dial = "localhost:8080"; }];
      }];
    }];

    # Create credentials file for nextcloud
    secrets.nextcloud = {
      source = ../../private/nextcloud.age;
      dest = "${config.secretsDirectory}/nextcloud";
      owner = "nextcloud";
      group = "nextcloud";
      permissions = "0440";
    };
    systemd.services.nextcloud-secret = {
      requiredBy = [ "nextcloud-setup.service" ];
      before = [ "nextcloud-setup.service" ];
    };

    ## Backup config

    # Open to groups, allowing for backups
    systemd.services.phpfpm-nextcloud.serviceConfig.StateDirectoryMode =
      lib.mkForce "0770";

    # Allow litestream and nextcloud to share a sqlite database
    users.users.litestream.extraGroups = [ "nextcloud" ];
    users.users.nextcloud.extraGroups = [ "litestream" ];

    # Backup sqlite database with litestream
    services.litestream = {
      enable = true;
      settings = {
        dbs = [{
          path = "${config.services.nextcloud.datadir}/data/nextcloud.db";
          replicas = [{
            url =
              "s3://${config.backupS3.bucket}.${config.backupS3.endpoint}/nextcloud";
          }];
        }];
      };
      environmentFile = config.secrets.backup.dest;
    };

    # Don't start litestream unless nextcloud is up
    systemd.services.litestream = {
      after = [ "phpfpm-nextcloud.service" "backup-secret.service" ];
      requires = [ "phpfpm-nextcloud.service" "backup-secret.service" ];
      environment.AWS_ACCESS_KEY_ID = config.backupS3.accessKeyId;
    };

  };

}
