{ ... }:
{
  home.stateVersion = "24.11";

  dconf.settings = {
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [ "steam.desktop" ];
    };
  };
}
