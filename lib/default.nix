context:
{
  nixpkgs-for-system = import ./nixpkgs-for-system.nix context;
  supported-platforms = import ./supported-platforms.nix context;
  universal-packages = import ./universal-packages.nix context;
}
