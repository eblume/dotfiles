# Fix: https://github.com/janeczku/calibre-web/issues/2422

final: prev: {
  calibre-web = prev.calibre-web.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./calibre-web-cloudflare.patch ];
  });
}
