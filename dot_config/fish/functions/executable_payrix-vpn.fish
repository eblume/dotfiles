function payrix-vpn --description="Start the payrix openvpn client using sudo"
    # Note that these alphanumeric strings are not secrets, but just UIDS from 1password.

    sudo openvpn --config (op document --vault jpurcmohy6ayoy56xv2sf4jete get sozlppl5w45ipdhyy5jpjen6o4 | psub)
end
