{ config, pkgs, lib, ... }:
{
  programs.nixvim = {
    enable = true;
    
    nixpkgs.config.allowUnfree = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    plugins = {
      copilot-vim = {
        enable = false;
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
        settings = {
          sources = [
            {
              name = "minuet";
              group_index = 1;
              priority = 100;
            }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          #performance = {
            # Increase timeout for LLM responses
          #  fetching_timeout = 2000;
          #};
          mapping = {
            # Manual completion trigger for minuet
            "<A-y>" = "cmp.mapping(require('minuet').make_cmp_map())";
            # Accept completion
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            # Navigate completion menu
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
        };
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
        settings = {
            respect_buf_cwd = true;
        };
      };

      web-devicons = {
        enable = true;
      };

      minuet = {
        enable = true;
        settings = {
          provider = "openai_fim_compatible";
          n_completions = 1; # Recommended for local models for resource saving
          context_window = 16000; # Starting point, adjust based on computing power
          provider_options = {
            openai_fim_compatible = {
              api_key = "TERM";
              name = "Ollama";
              end_point = "http://localhost:11434/v1/completions";
              model = "qwen2.5-coder:7b";
              optional = {
                max_tokens = 56;
                top_p = 0.9;
              };
            };
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

