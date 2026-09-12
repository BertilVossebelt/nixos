# Bluetooth stack (BlueZ). Harmless on machines without a BT adapter (e.g. the
# wired desktop); the AGS control-center toggle only appears where one exists.
{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
