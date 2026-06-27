{ pkgs, lib, systemName, ... }:
{
  config = lib.mkIf (systemName == "work") {
    programs.opencode.settings.mcp.atlassian = {
      type = "remote";
      url = "https://mcp.atlassian.com/v1/mcp/authv2";
      enabled = true;
    };

    programs.opencode.settings.mcp.slack = {
      type = "remote";
      url = "https://mcp.slack.com/mcp";
      enabled = true;
      oauth = {
        clientId = "1601185624273.8899143856786";
        redirectUri = "http://localhost:3118/callback";
      };
    };

    programs.opencode.settings.mcp.mail = {
      type = "local";
      command = ["apple-mail-mcp"];
      enabled = true;
    };

    programs.opencode.settings.mcp.megaten_fusion.enabled = lib.mkForce false;

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
        apple-mail-mcp
    ];
  };
}
