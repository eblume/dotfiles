function payrix-api-pci --description="Run a curl against the prodpci api"
    set -f vault_id jpurcmohy6ayoy56xv2sf4jete
    set -f api_key_id 2haen3o5fhkuj2zhtqtrrxe7gq
    set -f api_key (op --vault $vault_id item get $api_key_id --fields credential --reveal)
    set -f api_host 'admin-api.payrix.com'
    set -f endpoint $argv[1]
    set -f extra_args $argv[2..-1]

    curl --location \
        --header "Content-Type: application/json" \
        --header "APIKEY: $api_key" \
        "https://$api_host/$endpoint" \
        $extra_args
end
