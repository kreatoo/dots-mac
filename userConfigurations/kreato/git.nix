{
  programs,
  ...
}: {
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;

  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git = {
      pagers = [
        { pager = "delta --dark --paging=never"; }
      ];
    };
  };
}
