function devpi --description="Toggle private PyPI indexes (devpi + Forgejo Packages)" --argument-names=cmd
    set -l devpi_url "https://pypi.ops.eblu.me/root/pypi/+simple/"
    set -l forgejo_url "https://forge.eblu.me/api/packages/eblume/pypi/simple/"

    switch "$cmd"
        case on
            if not curl -sf --connect-timeout 3 "$devpi_url" >/dev/null 2>&1
                echo "devpi is not reachable at $devpi_url"
                return 1
            end
            set -Ux DEVPI_ENABLED 1
            # Legacy vars for pip compatibility
            set -gx PIP_INDEX_URL "$devpi_url"
            # New-style uv index config:
            #   UV_INDEX (checked first) → Forgejo Packages (our private packages)
            #   UV_DEFAULT_INDEX (fallback) → devpi (pull-through cache of PyPI)
            # uv's first-index strategy means: if a package name exists on Forgejo,
            # it won't check devpi/PyPI for it. This prevents dependency confusion
            # with same-named packages on public PyPI.
            set -gx UV_INDEX "forgejo=$forgejo_url"
            set -gx UV_DEFAULT_INDEX "$devpi_url"
            set -e UV_INDEX_URL  # clear legacy var to avoid conflict
            echo "Private indexes enabled (Forgejo Packages + devpi)"
        case off
            set -Ux DEVPI_ENABLED 0
            set -e PIP_INDEX_URL
            set -e UV_INDEX
            set -e UV_DEFAULT_INDEX
            set -e UV_INDEX_URL
            echo "Private indexes disabled (using public PyPI)"
        case status ''
            if test "$DEVPI_ENABLED" = 1
                echo "Private indexes: enabled"
                echo "  UV_INDEX:         $UV_INDEX"
                echo "  UV_DEFAULT_INDEX: $UV_DEFAULT_INDEX"
                echo "  PIP_INDEX_URL:    $PIP_INDEX_URL"
                if curl -sf --connect-timeout 3 "$devpi_url" >/dev/null 2>&1
                    echo "  devpi reachable: yes"
                else
                    echo "  devpi reachable: no"
                end
            else
                echo "Private indexes: disabled (using public PyPI)"
            end
        case '*'
            echo "Usage: devpi [on|off|status]"
            return 1
    end
end
