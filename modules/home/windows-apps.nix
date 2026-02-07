{ pkgs, ... }:

let
  runVM = "virt-viewer --connect qemu:///system win11";
in
{
  home.packages = [ pkgs.virt-viewer ];

  xdg.desktopEntries = {
    capture-one = {
      name = "Capture One";
      exec = runVM;
      icon = "camera-photo";
      categories = [ "Graphics" ];
    };

    affinity-photo = {
      name = "Affinity Photo";
      exec = runVM;
      icon = "applications-graphics";
      categories = [ "Graphics" ];
    };

    affinity-designer = {
      name = "Affinity Designer";
      exec = runVM;
      icon = "applications-graphics";
      categories = [ "Graphics" ];
    };

    word = {
      name = "Microsoft Word";
      exec = runVM;
      icon = "x-office-document";
      categories = [ "Office" ];
    };

    excel = {
      name = "Microsoft Excel";
      exec = runVM;
      icon = "x-office-spreadsheet";
      categories = [ "Office" ];
    };
  };
}
