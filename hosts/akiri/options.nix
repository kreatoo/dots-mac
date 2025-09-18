# Main configuration file for akiri
{
  hostName = "akiri";
  userName = "kreato";
  
  # Global time settings
  time = {
    # Choose your system timezone, e.g. "America/Los_Angeles", "Europe/Berlin"
    timeZone = "Europe/Istanbul";
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
        "xda-developers"
      ];
    };
  };

  # Homebrew toggle
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
