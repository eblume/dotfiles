# Use private PyPI indexes when enabled
# Toggle with: devpi on | devpi off | devpi status
if test "$DEVPI_ENABLED" = 1
    set -gx PIP_INDEX_URL "https://pypi.ops.eblu.me/root/pypi/+simple/"
    set -gx UV_INDEX "forgejo=https://forge.eblu.me/api/packages/eblume/pypi/simple/"
    set -gx UV_DEFAULT_INDEX "https://pypi.ops.eblu.me/root/pypi/+simple/"
    set -e UV_INDEX_URL  # clear legacy var to avoid conflict
end
