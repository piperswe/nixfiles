{ nodejs, yarn, yarn2nix, esbuild, mkYarnPackage }:
mkYarnPackage {
  name = "nix-cache-piperswe-me-0.1.0";
  pname = "nix-cache-piperswe-me";
  version = "0.1.0";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  extraBuildInputs = [
    nodejs
    yarn
    yarn2nix
    esbuild
  ];
  buildPhase = ''
    dist=$out/artifacts
    mkdir -p $dist
    cp $src/index.html $dist/
    cp $src/index.js $src/index.css .
    esbuild index.js index.css --bundle --minify --sourcemap --outdir=$dist --target=chrome58,firefox57,safari11,edge16
  '';
}
