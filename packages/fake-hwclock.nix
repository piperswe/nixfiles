{ stdenv, lib, fetchgit }:
stdenv.mkDerivation rec {
  pname = "fake-hwclock";
  version = "0.12";

  src = fetchgit {
    url = "https://git.einval.com/git/fake-hwclock.git";
    rev = "v${version}";
    sha256 = "sha256-8wsCSJe3x9Flr2Wc7Cu8VfQyhjs3eqrOa9rmjoDp2ig=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/man
    cp $src/fake-hwclock $out/bin/
    cp $src/fake-hwclock $out/share/man/
  '';

  meta = with lib; {
    description = "Save/restore system clock on machines without working RTC hardware";
    homepage = "https://git.einval.com/cgi-bin/gitweb.cgi?p=fake-hwclock.git;a=summary";
    license = licenses.gpl2;
    # I'm not in the maintainers list... yet!
    # maintainers = with maintainers; [ pmc ];
    platforms = platforms.linux;
  };
}
