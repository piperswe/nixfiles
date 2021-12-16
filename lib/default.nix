context:
{
  nixpkgs-for-system = import ./nixpkgs-for-system.nix context;
  ssh-keys = import ./ssh-keys.nix context;
  supported-platforms = import ./supported-platforms.nix context;
  universal-packages = import ./universal-packages.nix context;
}
