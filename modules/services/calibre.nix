{ config, pkgs, lib, ... }:

let

  # Must set group owner to calibre-web
  libraryPath = "/var/books";

in {

  options = {
    bookServer = lib.mkOption {
      type = lib.types.str;
      description = "Hostname for Calibre library";
    };
  };

  config = {

    services.calibre-web = {
      enable = true;
      openFirewall = true;
      options = {
        calibreLibrary = libraryPath;
        reverseProxyAuth.enable = false;
        enableBookConversion = true;
      };
    };

    services.caddy = {
      enable = true;
      adapter = "''"; # Required to enable JSON
      configFile = pkgs.writeText "Caddyfile" (builtins.toJSON {
        apps.http.servers = {
          calibre = {
            listen = [ ":443" ];
            routes = [{
              match = [{ host = [ config.bookServer ]; }];
              handle = [{
                handler = "reverse_proxy";
                upstreams = [{ dial = "localhost:8083"; }];
                headers.request.add."X-Script-Name" = [ "/calibre-web" ];
              }];
            }];
          };
        };
      });

    };

    networking.firewall.interfaces.calibre = { allowedTCPPorts = [ 80 443 ]; };

    # Create directory and set permissions
    system.activationScripts.calibreLibrary.text = ''
      if [ ! -d "${libraryPath}" ]; then
          $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG ${libraryPath}
      fi
      if [ ! "$(stat -c "%G" ${libraryPath})" = "calibre-web" ]; then
          $DRY_RUN_CMD chown $VERBOSE_ARG -R calibre-web:calibre-web ${libraryPath}
      fi
      if [ ! "$(stat -c "%a" ${libraryPath})" = "775" ]; then
          $DRY_RUN_CMD chmod $VERBOSE_ARG 0775 ${libraryPath}
          $DRY_RUN_CMD chmod $VERBOSE_ARG -R 0640 ${libraryPath}/*
      fi
    '';

  };

}
