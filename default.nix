{
  overlay = import ./dhall-haskell/overlay.nix;
  completion = shell : ''
    source <(dhall         --${shell}-completion-script dhall)
    source <(dhall-to-text --${shell}-completion-script dhall-to-text)
    source <(dhall-to-bash --${shell}-completion-script dhall-to-bash)
    source <(dhall-to-nix  --${shell}-completion-script dhall-to-nix)
    source <(dhall-to-json --${shell}-completion-script dhall-to-json)
    source <(dhall-to-yaml --${shell}-completion-script dhall-to-yaml)
    source <(json-to-dhall --${shell}-completion-script json-to-dhall)
  '';
}
