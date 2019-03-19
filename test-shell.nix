with import <nixpkgs> { overlays = [ (import ./.) ] ;};
runCommand "dhall-haskell-all" {
  buildInputs = [
    dhall-bin
    dhall-json-bin
    dhall-text-bin
    dhall-bash-bin
  ];
  shellHook = ''
    echo "Dhall core tools shell"
    '';
} ""

