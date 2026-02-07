{ pkgs, ... }:

let
  virtioIso = pkgs.fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/latest/images/virtio-win.iso";
    sha256 = "1bxgfk7gfnw5mfcqcmrljb5clyd6ynjcb7km5s4ysfjy13ftbms9";  # Checksum, update if changed.
  };

  winDomainXML = pkgs.writeText "win11.xml" ''
  <domain type='kvm'>
    <name>win11</name>
    <memory unit='MiB'>12288</memory>
    <vcpu>8</vcpu>
    <os>
      <type arch='x86_64' machine='q35'>hvm</type>
      <loader readonly='yes' type='pflash'>/nix/store/...-OVMF-202508.01-fd/FV/OVMF.fd</loader>
      <nvram>/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
    </os>
    <features>
      <acpi/>
      <apic/>
      <vmport state='off'/>
    </features>
    <cpu mode='host-passthrough'/>
    <devices>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2'/>
        <source file='/var/lib/libvirt/images/win11.qcow2'/>
        <target dev='vda' bus='virtio'/>
      </disk>

      <disk type='file' device='cdrom'>
        <source file='/var/lib/libvirt/images/virtio-win.iso'/>
        <target dev='sdb' bus='sata'/>
        <readonly/>
      </disk>

      <interface type='network'>
        <source network='default'/>
        <model type='virtio'/>
      </interface>

      <graphics type='spice'>
        <listen type='none'/>
      </graphics>

      <video>
        <model type='virtio' heads='1' primary='yes'/>
      </video>

      <input type='tablet' bus='usb'/>
      <tpm model='tpm-crb'>
        <backend type='emulator'/>
      </tpm>
    </devices>
  </domain>
  '';
in
{
  systemd.services.define-win11-vm = {
    description = "Define Windows 11 VM declaratively";
    wants = [ "libvirt-default-network.service" ];
    after = [ "libvirt-default-network.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      # Use the correct paths for bash, mkdir, etc.
      ExecStartPre = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/libvirt/images
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/libvirt/qemu/nvram
        test -f /var/lib/libvirt/qemu/nvram/win11_VARS.fd || \
        cp ${pkgs.OVMF}/FV/OVMF_VARS.fd /var/lib/libvirt/qemu/nvram/win11_VARS.fd
        cp ${virtioIso} /var/lib/libvirt/images/virtio-win.iso
      '';

      ExecStart = ''
        ${pkgs.coreutils}/bin/bash -c "${pkgs.libvirt}/bin/virsh -c qemu:///system dominfo win11 >/dev/null 2>&1 || \
        ${pkgs.libvirt}/bin/virsh -c qemu:///system define ${winDomainXML}"
      '';
    };

    wantedBy = [ "multi-user.target" ];
    enable = true;
  };
}
