{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    file = {
      ".config/BetterDiscord/plugins/LaTeX.plugin.js".source =
        inputs.discord-latex + /dist/LaTeX.plugin.js;
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
