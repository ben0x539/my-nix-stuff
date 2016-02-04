{ stdenv, fetchFromGitHub, fetchFromBitbucket,
  autoconf, automake, libtool,
  pidgin, glib, json_glib, zlib }:

stdenv.mkDerivation rec {
  name = "pidgin-facebook-${version}";
  version = "92885e0456ed";

  src = fetchFromGitHub {
    owner = "jgeboski";
    repo = "purple-facebook";
    rev = "e30dc458e701eda4af8eaefed33ac2dcd28f5d7d";
    sha256 = "1p3f4z2xlnak7lfxcsv2fgb4h5q88psc6kr8s3amghlzxn2v3sf8";
  };

  pidginSrc = fetchFromBitbucket {
    owner = "pidgin";
    repo = "main";
    rev = version;
    sha256 = "1ds5xnzip63z6i5084qhjz3z8gy8barr679xldg1ylalvqgr02rc";
  };

  postUnpack = ''
    cp -R "$pidginSrc" "$sourceRoot"/.pidgin
    chmod -R u+w "$sourceRoot"/.pidgin
    mkdir "$sourceRoot"/.pidgin/.hg
    mkdir dummy_hg
    echo 'echo skipping: hg "$@"' > dummy_hg/hg
    chmod a+x dummy_hg/hg
    PATH="$PATH:$(pwd)/dummy_hg"
  '';

  configureScript  = "./autogen.sh";

  nativeBuildInputs = [ autoconf automake libtool ];

  buildInputs = [ pidgin zlib glib json_glib ];

  configureFlags = "PURPLE_PLUGINDIR=$(out)/lib/purple-2/";

  meta = with stdenv.lib; {
    homepage = https://github.com/jgeboski/purple-facebook;
    description = "Facebook protocol plugin for libpurple https://pidgin.im";
    license = licenses.gpl2;
    platforms = platforms.linux;
    #maintainers = with maintainers; [  ];
  };
}
