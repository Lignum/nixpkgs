{ lib
, stdenv
, fetchFromGitLab
, substituteAll
, symlinkJoin

, openconnect
, vpnc-scripts

, gnutls
, libtasn1
, libidn2
, p11-kit
, stoken

, Security
, spdlog

, wrapQtAppsHook
, qtbase
, qtscxml
, qtsingleapplication
, qtwayland

, cmake
, ninja
, pkg-config
, ...
}:
let
  openconnect-with-vpnc-scripts =
    symlinkJoin {
      pname = "openconnect-with-vpnc-scripts";
      inherit (openconnect) version;

      postBuild = ''
        mkdir -p $out/etc/vpnc
        cp $out/bin/vpnc-script $out/etc/vpnc/vpnc-script
      '';

      paths = [
        openconnect
        openconnect.dev # needed for pkg-config
        vpnc-scripts
      ];
    };
in
stdenv.mkDerivation rec {
  pname = "openconnect-gui";
  version = "1.6.2";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "openconnect-gui";
    rev = "v${version}";
    hash = "sha256-6dc59GPq08Wt1W3oHE1x7VPeQTxwLKWsWtWGJN9SfZA=";
  };

  patches = [
    # The project depends on qt-solutions/qtsingleapplication by cloning it via CMake's ExternalProject_Add.
    # We already use a custom CMakeLists.txt for qtsingleapplication, which also generates a .cmake file.
    # cmake-qt-solutions.patch replaces the explicit dependency with an include(..) call to that file.
    (substituteAll {
      src = ./patches/cmake-qt-solutions.patch;
      libDir = "${qtsingleapplication.dev}/lib";
    })

    # CMake's fixup_bundle conflicts with wrapQtAppsHook. Since they serve basically the same
    # purpose, it suffices to just remove it entirely.
    ./patches/cmake-no-fixup-bundle.patch
  ];

  nativeBuildInputs = [ wrapQtAppsHook ninja cmake pkg-config ];

  buildInputs =
    [
      qtbase
      qtscxml # contains the StateMachine module
      qtsingleapplication

      gnutls
      libtasn1
      libidn2
      p11-kit
      stoken

      spdlog
      openconnect-with-vpnc-scripts
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [ Security ])
    ++ (lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ]);

  meta = with lib; {
    description = "Graphical Qt6 frontend for openconnect";
    homepage = "https://gitlab.com/openconnect/openconnect-gui";
    license = licenses.gpl2Only;
    mainProgram = "openconnect-gui";

    # The vpnc-scripts package is available on these platforms but given an alternative implementation,
    # openconnect-gui could run on other platforms as well, as long as Qt6 is supported.
    platforms = platforms.linux ++ platforms.darwin;
  };
}
