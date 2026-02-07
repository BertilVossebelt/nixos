{ lib, pkgs, ... }:

let
  VIRSH="${pkgs.libvirt}/bin/virsh -c qemu:///system";

  defaultNetXML = pkgs.writeText "default-network.xml" ''
    <network>
      <name>default</name>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <ip address='192.168.122.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.2' end='192.168.122.254'/>
        </dhcp>
      </ip>
    </network>
  '';

  startDefaultNet = pkgs.writeShellScript "start-default-network" ''
    #!/bin/sh
    set -e

    ${VIRSH} net-info default >/dev/null 2>&1 || ${VIRSH} net-define ${defaultNetXML} || true
    ${VIRSH} net-autostart default || true
    ${VIRSH} net-start default || true
'';
in
{
  systemd.services.libvirt-default-network = {
    description = "Ensure libvirt default network is active";
    wants = [ "libvirtd.service" "libvirtd.socket" ];
    after = [ "libvirtd.service" "libvirtd.socket" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${startDefaultNet}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
