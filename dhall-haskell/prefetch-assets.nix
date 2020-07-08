let
  release = with builtins; fromJSON (readFile ./github.release.latest.json);
  extractAsset = a:
  # let i = match "^(([a-zA-Z]+)(-[a-zA-Z]+)?)-([0-9\.]+)-([^\.]+)(.*)$" a.name;
  # TODO Add some user-friendly way to test this regex!
  let i = builtins.match
          "^(([a-zA-Z]+)(-[a-zA-Z]+)*)-([0-9\.]+)-([^\.]+)(.*)$" a.name;
  in if i == null then {} else {
    nameCore = builtins.elemAt i 0;
    version  = builtins.elemAt i 3;
    platform = builtins.elemAt i 4;
    urlsha = {
      url    = a.browser_download_url;
      sha256 = "$(nix-prefetch-url ${a.browser_download_url})";
    };
    # data = a;
  };
in
  # filter (a: a ? "nameCore") (map extractAsset release.assets)
  # Keeping only linux binaries (TODO control this by a nix function arg)
  # test = (
  builtins.filter (a: a.platform or "" == "x86_64-linux")
    (map extractAsset release.assets)
  # )
  # builtins.toFile "test" ( builtins.toJSON test )
