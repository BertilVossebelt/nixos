# /etc/nixos/modules/system/audio.nix
{ config, pkgs, ... }:

{
  # Audio
  security.rtkit.enable = true;

  # Disable PulseAudio to avoid conflicts with Pipewire
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing (requires audio for some apps that use libav)
  services.printing.enable = true;
}
