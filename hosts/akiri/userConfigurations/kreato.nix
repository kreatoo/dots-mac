{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.stateVersion = "24.11";

  # Packages
  home.packages = with pkgs; [
    nodejs
    fzf
    nixfmt-rfc-style
  ];

  # ZSH
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.shellAliases = {
    ls = "eza";
    clean-gc = "sudo nix-collect-garbage --delete-old";
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Neovim
  programs.neovim = {
    enable = true;
    coc.enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-treesitter.withAllGrammars
      vim-fugitive
      embark-vim
      dashboard-nvim
      copilot-vim
      colorizer
      nerdtree
      fzf-vim
    ];
    extraLuaConfig = ''
            vim.cmd.colorscheme('embark')
      	  vim.opt.shiftwidth = 4
      	  
      	  require('nvim-treesitter.configs').setup {
      	    highlight = {
      	      enable = true,
      	    },
      	  }
            
      	  vim.o.tabstop = 4
      	  vim.o.termguicolors = true
      	  vim.o.updatetime = 300
      	  vim.o.incsearch = false
      	  vim.wo.signcolumn = "yes"
      	  vim.wo.number = true
      	  '';
  };
}
