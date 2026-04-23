let
  vars = import ./options.nix;
in
{
  homebrew = {
    enable = vars.homebrew.enable;

    onActivation = {
      autoUpdate = vars.homebrew.autoUpdate;
      cleanup = if vars.homebrew.declarative then "uninstall" else "none";
    };

    taps = [ ];
  };
}
