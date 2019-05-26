with builtins;
let
  release = fromJSON (readFile ./github.release.latest.json);
  extractAsset = a:
  # let i = match "^(([a-zA-Z]+)(-[a-zA-Z]+)?)-([0-9\.]+)-([^\.]+)(.*)$" a.name;
  let i = match "^(([a-zA-Z]+)(-[a-zA-Z]+)*)-([0-9\.]+)-([^\.]+)(.*)$" a.name;
  in {
    nameCore = elemAt i 0;
    version  = elemAt i 3;
    platform = elemAt i 4;
    urlsha = {
      url    = a.browser_download_url;
      sha256 = "$(nix-prefetch-url ${a.browser_download_url})";
    };
    # data = a;
  };
in
  map extractAsset release.assets
