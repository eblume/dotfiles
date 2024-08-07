{ config, ... }:
{
  config = {
    security.pki.certificateFiles = [ "/etc/nix/ca_cert.pem" ]; # Manually placed
    home-manager.users.${config.user} = {
      # Throw it all at the wall and see what sticks
      home.sessionVariables = {
        SSL_CERT_FILE = "/etc/nix/ca_cert.pem";
        AWS_CA_BUNDLE = "/etc/nix/ca_cert.pem";
        REQUESTS_CA_BUNDLE = "/etc/nix/ca_cert.pem";
        CURL_CA_BUNDLE = "/etc/nix/ca_cert.pem";
        NODE_EXTRA_CA_CERTS = "/etc/nix/ca_cert.pem";
      };
    };
  };
}
