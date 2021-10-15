{ stdenv, lib, makeWrapper, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "update-machine";
  version = "0.1";

  src = ./.;

  propagatedBuildInputs = [
    python3Packages.GitPython
  ];

  meta = with lib; {
    description = "Update a NixOS machine using this flake";
    license = licenses.mit;
    # I'm not in the maintainers list... yet!
    # maintainers = with maintainers; [ pmc ];
    platforms = platforms.all;
  };
}
