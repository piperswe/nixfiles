context:
# Modified from https://github.com/NixOS/nixpkgs/blob/master/lib/systems/supported.nix
rec {
  hydra = tier1 ++ tier2 ++ tier3;

  tier1 = [
    "x86_64-linux"
  ];

  tier2 = [
    "aarch64-linux"
    "x86_64-darwin"
  ];

  tier3 = [
    "aarch64-darwin"
    "armv6l-linux"
    "armv7l-linux"
    "i686-linux"
  ];
}
