{ nixpkgs-piper-bootstrap, ... }:
let
  make-bootstrap-tools-cross = import "${nixpkgs-piper-bootstrap}/pkgs/stdenv/linux/make-bootstrap-tools-cross.nix" { system = "x86_64-linux"; };
  tools = arch: make-bootstrap-tools-cross.${arch}.dist;
in
{
  powerpc64le-linux = tools "powerpc64le";
  sparc64-linux = tools "sparc64";
}
