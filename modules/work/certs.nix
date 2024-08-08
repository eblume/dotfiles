{ config, lib, ... }:
let
  # Manually placed. See [[1723066665-JZBU]].
  cert_file = "/etc/nix/ca_cert.pem";
in
{

  options.use_custom_root_cert = lib.mkEnableOption "Custom Root CA Cert";

  config = lib.mkIf config.use_custom_root_cert {
    security.pki.certificateFiles = [ cert_file ]; # Manually placed
    home-manager.users.${config.user} = {
      # Throw it all at the wall and see what sticks
      home.sessionVariables = {
        SSL_CERT_FILE = cert_file;
        AWS_CA_BUNDLE = cert_file;
        REQUESTS_CA_BUNDLE = cert_file;
        CURL_CA_BUNDLE = cert_file;
        NODE_EXTRA_CA_CERTS = cert_file;
        NIX_SSL_CERT_FILE = cert_file;
      };
    };
  };
}
