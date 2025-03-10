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
    luarocks
    nixfmt-rfc-style
  ];

  # ZSH
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.history.path = "\${PROFILE_HISTFILE:-$HOME/.zsh_history}";
  programs.zsh.shellAliases = {
    ls = "eza";
	cat = "bat";
    e = "gh copilot explain";
    r = "gh copilot suggest";
    clean-gc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage --delete-old";
  };
  
  programs.zsh.initExtra = ''
    if [[ "$WORK_PROFILE" = "true" ]]; then  
        alias ssh="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
        alias scp="scp -o UserKnownHostsFile=~/.ssh/known_hosts_work"
        export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=~/.ssh/known_hosts_work"
    fi
    '';

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Nushell
  programs.nushell = {
    enable = true;
    shellAliases = {
      cat = "bat";
      rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin#akiri";
      e = "gh copilot explain";
      r = "gh copilot suggest";
    };

    configFile = {
        source = ./nushell/config.nu;
    };

    envFile.text = ''
        for item in ["/Users/kreato/.nix-profile/bin" "/etc/profiles/per-user/kreato/bin" "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/opt/homebrew/bin" "/Users/kreato/.krew/bin" ] {
            $env.Path = ($env.Path | append $item)
        }

        $env.config.buffer_editor = "nvim"
        $env.config.show_banner = false
    '';
  };

  home.file."./.config/sketchybar/" = {
  	source = ./sketchybar;
	recursive = true;
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
      	 
		  require('dashboard').setup {}

      	  require('nvim-treesitter.configs').setup {
      	    highlight = {
      	      enable = true,
      	    },
      	  }

		  require('lualine').setup {
		  	options = {
				theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
            }
		  }

      	  vim.o.tabstop = 4
      	  vim.o.termguicolors = true
      	  vim.o.updatetime = 300
      	  vim.o.incsearch = false
      	  vim.wo.signcolumn = "yes"
      	  vim.wo.number = true
		  vim.o.expandtab = true
		  vim.o.smartindent = true
      	  '';
  };
}
