function devpi --description="Toggle devpi PyPI proxy" --argument-names=cmd
    set -l devpi_url "https://pypi.ops.eblu.me/root/pypi/+simple/"

    switch "$cmd"
        case on
            if not curl -sf --connect-timeout 3 "$devpi_url" >/dev/null 2>&1
                echo "devpi is not reachable at $devpi_url"
                return 1
            end
            set -Ux DEVPI_ENABLED 1
            set -gx PIP_INDEX_URL "$devpi_url"
            set -gx UV_INDEX_URL "$devpi_url"
            echo "devpi enabled"
        case off
            set -Ux DEVPI_ENABLED 0
            set -e PIP_INDEX_URL
            set -e UV_INDEX_URL
            echo "devpi disabled (using public PyPI)"
        case status ''
            if test "$DEVPI_ENABLED" = 1
                echo "devpi: enabled"
                echo "  PIP_INDEX_URL: $PIP_INDEX_URL"
                echo "  UV_INDEX_URL:  $UV_INDEX_URL"
                if curl -sf --connect-timeout 3 "$devpi_url" >/dev/null 2>&1
                    echo "  reachable: yes"
                else
                    echo "  reachable: no"
                end
            else
                echo "devpi: disabled (using public PyPI)"
            end
        case '*'
            echo "Usage: devpi [on|off|status]"
            return 1
    end
end
