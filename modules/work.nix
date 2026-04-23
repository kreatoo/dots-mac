{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
  ];

  homebrew.casks = [
    "google-chrome"
    "microsoft-teams"
    "balenaetcher"
  ];
}
