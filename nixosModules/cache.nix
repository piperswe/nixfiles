{ ... }:
{ ... }:
{
  nix = {
    binaryCaches = [
      "https://nix-cache.piperswe.me"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-cache.piperswe.me:4r7vyJJ/0riN8ILB+YhSCnYeynvxOeZXNsPNV4Fn8mE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
