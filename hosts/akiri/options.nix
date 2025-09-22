# Main configuration file for akiri
{
  # Basic system settings
  hostName = "akiri";
  userName = "kreato";
  
  # Global time settings
  time = {
    # Choose your system timezone, e.g. "America/Los_Angeles", "Europe/Berlin"
    timeZone = "Europe/Istanbul";
  };

  # Global security settings
  security = {
    sudo = {
        touchIdAuth = true;
    };
  };

  # Simple service toggles and options
  services = {
    autokbisw = {
      enable = true;
      startOnLogin = true;
    };
    
    colima = {
      enable = true;
      startOnLogin = true;
    };
    
    spoofdpi = {
      enable = true;
      enableDoh = true;
      windowSize = 1;
      startOnLogin = true;
      patterns = [
        "discord"
        "discordapp"
        "nyaa"
        "gelbooru"
        "danbooru"
        "tumblr"
        "4chan"
        "hianime"
        "pastebin"
        "wikihow"
        "protonvpn"
        "e-hentai"
        "mullvad"
        "guilded"
        "siker"
      ];
    };
  };

  # Homebrew toggle
  homebrew = {
    enable = true;
    autoUpdate = true;
    declarative = true;
  };


  # Window management tools
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
