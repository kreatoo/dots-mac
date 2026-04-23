{
  userName = "kreato";
  hostName = "work";

  time = {
    timeZone = "Europe/Istanbul";
  };

  security = {
    sudo = {
      touchIdAuth = true;
    };
  };

  services = {
    colima = {
      enable = false;
      startOnLogin = true;
      options = {
        memory = "10";
      };
    };
  };

  homebrew = {
    enable = true;
    autoUpdate = true;
    declarative = true;
  };

  yabai = {
    enable = false;
    skhd = {
      enable = false;
    };
    sketchybar = {
      enable = false;
    };
  };
}
