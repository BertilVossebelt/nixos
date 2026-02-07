{ pkgs, inputs, ... }:

let
  # Wrap the AppImage into a Nix package
  upnote = pkgs.appimageTools.wrapType2 {
    pname = "upnote";
    version = "latest";
    src = inputs.upnote-src;

    # Extract the desktop file and icon from the AppImage for KDE integration
    extraInstallCommands = let
      contents = pkgs.appimageTools.extract {
        inherit (upnote) pname version src;
      };
    in ''
      install -m 444 -D ${contents}/upnote.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/upnote.desktop \
        --replace 'Exec=AppRun' 'Exec=upnote'
      cp -r ${contents}/usr/share/icons $out/share/
    '';

    # Dependencies required by Electron/UpNote
    extraPkgs = pkgs: with pkgs; [
      libsecret
      nss
      atk
      at-spi2-atk
      libdrm
      mesa
      alsa-lib
      cups
      pango
      cairo
    ];
  };
in
{
  home.packages = [ upnote ];
}
