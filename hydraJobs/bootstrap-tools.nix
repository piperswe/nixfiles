{ lib, nixpkgs, ... }:
let
  make-bootstrap-tools-cross = from: system: import "${lib.nixpkgs-for-system system}/pkgs/stdenv/linux/make-bootstrap-tools-cross.nix" { system = from; };
  make-bootstrap-tools = system: import "${lib.nixpkgs-for-system system}/pkgs/stdenv/linux/make-bootstrap-tools.nix" { localSystem = system; };
  cross-tools = arch: (make-bootstrap-tools-cross "x86_64-linux" "${arch}-linux").${arch}.dist;
  native-tools = arch: (make-bootstrap-tools "${arch}-linux").dist;
  tools = arch: {
    native = native-tools arch;
  } // (nixpkgs.lib.optionalAttrs (arch != "x86_64" && arch != "i386") {
    cross = cross-tools arch;
  });
in
builtins.listToAttrs
  (builtins.map
    (system:
      {
        name = system;
        value = tools (nixpkgs.lib.removeSuffix "-linux" system);
      }
    )
    (builtins.filter
      (x: (nixpkgs.lib.hasSuffix "-linux" x))
      lib.supported-platforms.hydra))
