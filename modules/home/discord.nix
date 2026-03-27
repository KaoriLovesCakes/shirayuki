{ pkgs, ... }:
{
  home = {
    file = {
      ".config/BetterDiscord/plugins/LaTeX.plugin.js".text = builtins.readFile (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/BinaryQuantumSoul/discord-latex/refs/heads/main/dist/LaTeX.plugin.js";
          hash = "sha256-KMznYwfxutSYgJgmS6mVhbYFOLypXh+Hmj/ziudM71U=";
        }
      );
      ".config/BetterDiscord/themes/Nightcord.theme.css".text = builtins.readFile (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/Tetralink/Nightcord-at-25-00-discord-theme/refs/heads/main/Nightcord.theme.css";
          hash = "sha256-73ykxp0UoLvHXak4H2P1gV/5aH9RRKYjW59ZiPY/f4E=";
        }
      );
      ".config/discord/settings.json".text = ''
        {
          "SKIP_HOST_UPDATE": true
        }
      '';
    };
    packages = with pkgs; [
      betterdiscordctl
      discord
    ];
  };
}
