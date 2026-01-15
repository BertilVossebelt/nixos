{ pkgs, ... }:

{
  home-manager.users.ajv = {
    home.username = "ajv";
    home.homeDirectory = "/home/ajv";
    home.stateVersion = "25.11";

    programs.git = {
      enable = true;
      settings.user.name = "BertilVossebelt";
      settings.user.email = "52101469+BertilVossebelt@users.noreply.github.com";
    };

    programs.zsh = {
      enable = true;
      oh-my-zsh.enable = true;
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    services.ssh-agent.enable = true;

    home.activation.generateSshKey = ''
      if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"

        ${pkgs.openssh}/bin/ssh-keygen \
          -t ed25519 \
          -f "$HOME/.ssh/id_ed25519" \
          -N ""

        chmod 600 "$HOME/.ssh/id_ed25519"
        chmod 644 "$HOME/.ssh/id_ed25519.pub"
      fi
    '';

    home.activation.fixNixosPermissions = ''
      if [ -d "/etc/nixos/.git" ]; then
        chown -R ajv:users /etc/nixos
      fi
    '';
  };
}
