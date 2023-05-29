function my_dns_records() {
    if [ -z "$1" ]; then
        echo "Usage: dns_records <domain>"
        return 1
    fi

    DOMAIN=$1

    echo "Fetching DNS records for $DOMAIN"
    for type in A AAAA CNAME MX NS SOA TXT; do
        echo "==================== $type ===================="
        dig +noall +answer $DOMAIN $type
    done
}

