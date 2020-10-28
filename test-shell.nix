with import <nixpkgs> { overlays = [ (import ./.).overlay ] ;};
runCommand "dhall-haskell-all" rec {
  buildInputs = [
    dhall-bin
    dhall-json-bin
    dhall-yaml-bin
    dhall-bash-bin
    dhall-nix-bin
    dhall-nixpkgs-bin
    dhall-lsp-server-bin
    dhall-docs-bin
    which
  ];
  # TODO: Possible to automate sourcing bash completions somehow?
  # https://github.com/NixOS/nixpkgs/issues/44434#issuecomment-410624170
  # ls $HOME/.nix-profile/etc/bash_completion.d
  shellHook = ''
    echo "Dhall core tools shell"
    echo "Loading bash completions:"
    '' + (
      builtins.concatStringsSep "\n" (
        map (p:
        ''
          # echo ${p}
          for e in ${p}/etc/bash_completion.d/*
          do
            echo `basename $e`
            source $e
          done
        '') buildInputs
      ));
} ""
