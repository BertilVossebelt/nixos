{ config, pkgs, ... }:

{
  system.stateVersion = "25.11";

  # Time / locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.firewall.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Network
  networking.networkmanager.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;  # disable PulseAudio system-wide
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;   # uncomment if you want JACK apps
  };

  # Printers
  services.printing.enable = true;

  # Zsh
  programs.zsh.enable = true;

  # Dconf
  programs.dconf.enable = true;

  # Turn off GUI passwords
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Flakes support
    nix.package = pkgs.nix;
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';
}
