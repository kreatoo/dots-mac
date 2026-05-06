{ pkgs, lib, systemName, ... }:
{
  config = lib.mkIf (systemName == "work") {
    programs.nushell.enable = lib.mkForce false;

    programs.nixvim = {
      plugins = {
        copilot-vim.enable = lib.mkForce true;
        copilot-lua.enable = lib.mkForce false;
        minuet.enable = lib.mkForce false;
        cmp.settings.sources = [
          { name = "copilot"; group_index = 1; priority = 100; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };

    home.packages = with pkgs; [
        sshpass
    ];
  };
}
