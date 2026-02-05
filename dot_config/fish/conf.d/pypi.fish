# Use private PyPI proxy (devpi on indri) when enabled
# Toggle with: devpi on | devpi off | devpi status
if test "$DEVPI_ENABLED" = 1
    set -gx PIP_INDEX_URL "https://pypi.ops.eblu.me/root/pypi/+simple/"
    set -gx UV_INDEX_URL "https://pypi.ops.eblu.me/root/pypi/+simple/"
end
