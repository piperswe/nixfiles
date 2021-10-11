{ ... }:
final: prev: (import ./pkgs.nix prev) // {
  openssh = prev.openssh.override {
    withFIDO = true;
  };
}
