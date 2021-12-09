context:
final: prev: (import ./pkgs.nix context prev) // {
  openssh = prev.openssh.override {
    withFIDO = true;
  };
}
