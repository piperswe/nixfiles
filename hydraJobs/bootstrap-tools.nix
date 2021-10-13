{ lib, ... }:
let
  make-bootstrap-tools-cross = system: import "${lib.nixpkgs-for-system system}/pkgs/stdenv/linux/make-bootstrap-tools-cross.nix" { system = "x86_64-linux"; };
  make-bootstrap-tools = system: import "${lib.nixpkgs-for-system system}/pkgs/stdenv/linux/make-bootstrap-tools.nix" { inherit system; };
  cross-tools = arch: (make-bootstrap-tools-cross "${arch}-linux").${arch}.dist;
  native-tools = arch: (make-bootstrap-tools "${arch}-linux").dist;
  tools = arch: {
    cross = cross-tools arch;
    native = native-tools arch;
  };
in
{
  powerpc64le-linux = tools "powerpc64le";
  sparc64-linux = tools "sparc64";
}
