context:
{
  aarch64-buildbox = import ./aarch64-buildbox.nix context;
  big-linux-box = import ./big-linux-box.nix context;
  hydra = import ./hydra.nix context;
  installer = import ./installer.nix context;
  nix-devbox = import ./nix-devbox.nix context;
}
