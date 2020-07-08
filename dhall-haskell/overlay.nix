self: pkgs:
with builtins;
let
  # release = import ./release.nix;
  assetsAll = fromJSON (readFile ./github.release.latest.prefetched.json);
  assetsLinux = filter (p: p.platform or "" == "x86_64-linux") assetsAll;
  assetAttrs = listToAttrs ( map
  (i: {name = i.nameCore + "-bin"; value = {inherit (i) version urlsha;};})
  assetsLinux );
  execs = {
    dhall-bin      = [ "dhall" ];
    # dhall-json-bin = [ "dhall-to-json" "json-to-dhall" "dhall-to-yaml" "yaml-to-dhall" ];
    dhall-json-bin = [ "dhall-to-json" "json-to-dhall" "dhall-to-yaml" ];
    dhall-yaml-bin = [ "yaml-to-dhall" "dhall-to-yaml-ng" ];
    dhall-bash-bin = [ "dhall-to-bash" ];
    dhall-nix-bin  = [ "dhall-to-nix" ];
    dhall-lsp-server-bin  = [ "dhall-lsp-server" ];
  };
  installPhaseFunc = exs:
  ''
    mkdir -p $out/bin
    mkdir -p $out/etc/bash_completion.d
  '' + (
    concatStringsSep "\n" (
      map (ex:
      ''
        install -D -m555 -T ${ex} $out/bin/${ex}
        $out/bin/${ex} --bash-completion-script $out/bin/${ex} > $out/etc/bash_completion.d/${ex}-completion.bash
      '') exs
    ));
  # patchelf = import ../common/patchelf.nix pkgs;
  derive = p: let n = p.nameCore + "-bin"; in {
    name = n;
    value = pkgs.stdenv.mkDerivation {
      name = n;
      version = p.version;
      src = fetchurl p.urlsha;
      installPhase = installPhaseFunc execs.${n};
    };
  };
in
  listToAttrs (map derive assetsLinux)

  # {
  # purs-bin = pkgs.stdenv.mkDerivation rec {
  #   name = "purs-bin";
  #   version = release.data.tag_name;
  #   src =
  #     if pkgs.stdenv.isDarwin
  #     then pkgs.fetchurl prefetched.macos_tar_gz
  #     else pkgs.fetchurl prefetched.linux64_tar_gz
  #     ;
  #   buildInputs = [ self.zlib
  #                   self.gmp
  #                   self.ncurses5
  #                 ];
  #   libPath = pkgs.lib.makeLibraryPath buildInputs;
  #   dontStrip = true;
  #   installPhase = ''
  #     mkdir -p $out/bin
  #     mkdir -p $out/etc/bash_completion.d
  #     # mkdir -p $out/share/bash-completion/completions
  #     EXE=$out/bin/purs
  #     install -D -m555 -T purs $EXE
  #     ${patchelf libPath}
  #     $EXE --bash-completion-script $EXE > $out/etc/bash_completion.d/bash-completion
  #     # install -D -m 444 <($EXE --bash-completion-script $EXE) $out/share/bash-completion/completions/purs
  #   '';
  #   # TODO: Bash completion not working (need to run the script in shell)
  #   # Bash completion is usually installed in postInstall but...
  #   # postInstall is apparently ignored here:
  #   postInstall = ''
  #     false
  #   '';
  # };
# }
