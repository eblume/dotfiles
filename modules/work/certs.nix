{ config, ... }:
let
  # Manually placed. See [[
  cert_file = "/etc/nix/ca_cert.pem";
in
{
  config = {
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
