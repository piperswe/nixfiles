context@{ nixpkgs, ... }:
packages:
let
  compatible = builtins.filter
    (pkg:
      if pkg ? "compatible"
      then pkg.compatible
      else true)
    packages;
in
builtins.map
  (maybePkg:
    if maybePkg ? "pkg"
    then maybePkg.pkg
    else maybePkg)
  compatible
