{ config, pkgs, lib, ... }:
{
  programs.nixvim = {
    enable = true;
    
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    plugins = {
      copilot-lua = {
        enable = true;
      };
      
      colorizer = {
        enable = true;
      };
      
      lualine = {
        enable = true;
        settings = {
          options = {
            component_separators = "";
            section_separators = { 
              left = ""; 
              right = "";
            };
          };
        };
      };

      cmp = {
        enable = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        autoEnableSources = true;
      };

      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
        };
      };
      
      dashboard = {
        enable = true;
      };

      nvim-tree = {
        enable = true;
        openOnSetup = true;
        respectBufCwd = true;
      };

      web-devicons = {
        enable = true;
      };

      avante = {
        enable = true;
        settings = {
          auto_suggestions_provider = "copilot";
          cursor_applying_provider = "copilot";
          behaviour = {
              auto_suggestions = true;
              auto_apply_diff_after_generation = true;
              #enable_cursor_planning_mode = true;
          };
          provider = "copilot";
          copilot = {     
            model = "o3-mini";
          };
          suggestion = {
              debounce = 800;
          }; 
        };
      };
    };

    opts = {
      shiftwidth = 4;
      tabstop = 4;
      termguicolors = true;
      updatetime = 300;
      incsearch = false;
      signcolumn = "yes";
      number = true;
      expandtab = true;
      smartindent = true;
    };
  };
}

