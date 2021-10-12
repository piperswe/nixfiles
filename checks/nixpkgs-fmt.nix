{ nixpkgs, root, ... }:
system:
nixpkgs.lib.optionalAttrs (system == "x86_64-linux")
  (
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    pkgs.runCommand "nixpkgs-fmt"
      {
        inherit root;
      }
      ''
        (
          echo checking through nixpkgs-fmt:
          files=$(ls $root/{,**/}*.nix)
          for file in $files
          do
            echo ' - '$file
          done
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check $files
        ) | tee $out
      ''
  )
