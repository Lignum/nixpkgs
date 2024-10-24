{ pkgs
, stdenv
, lib
, fetchFromGitHub
, qtbase
, qt5compat ? null
, ...
}:
stdenv.mkDerivation rec {
  pname = "qtsingleapplication";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "qtproject";
    repo = "qt-solutions";
    rev = "777e95ba69952f11eaec0adfb0cb987fabcdecb3";
    hash = "sha256-M2OjWhYgIboeMHUJkpvEW957b7gn4htar79RCXv/jRA=";
  };

  sourceRoot = "${src.name}/qtsingleapplication";
  outputs = [ "out" "dev" ];

  nativeBuildInputs = with pkgs; [
    qt6.wrapQtAppsHook
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [ qtbase ] ++ lib.optionals (qt5compat != null) [ qt5compat ];

  # openconnect-gui simply ignores the qmake project and provides its own CMakeLists.txt.
  # Our CMakeLists.txt is loosely based on that one. Most importantly, it exports a
  # CMake file which is then include(..)ed in the openconnect-gui derivation.
  postPatch = ''
    ln -s ${./CMakeLists.txt} CMakeLists.txt
  '';

  meta = with lib; {
    description = "QtSingleApplication from the (deprecated!) qt-solutions component";
    homepage = "https://code.qt.io/cgit/qt-solutions/qt-solutions.git/";
    license = licenses.bsd3;
    platforms = platforms.unix ++ platforms.windows;
  };
}
