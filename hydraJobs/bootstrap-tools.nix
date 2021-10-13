{ lib, ... }:
let
  make-bootstrap-tools-cross = system: import "${lib.nixpkgs-for-system system}/pkgs/stdenv/linux/make-bootstrap-tools-cross.nix" { system = "x86_64-linux"; };
  tools = arch: (make-bootstrap-tools-cross "${arch}-linux").${arch}.dist;
in
{
  powerpc64le-linux = tools "powerpc64le";
  sparc64-linux = tools "sparc64";
}
