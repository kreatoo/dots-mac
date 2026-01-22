{
  config,
  pkgs,
  lib,
  uopts,
  ...
}:
{
  programs.nixvim = {
    enable = true;

    nixpkgs.config.allowUnfree = true;

    colorschemes = {
      catppuccin = {
        enable = false;
        settings = {
          flavour = "mocha";
        };
      };

      kanagawa = {
        enable = false;
        settings = {
          background = {
            dark = "dragon";
          };
        };
      };

      everforest = {
        enable = true;
        settings = {
          background = "hard";
        };
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
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                separator = {
                  left = "";
                  right = "";
                };
                padding = {
                  left = 1;
                  right = 1;
                };
              }
            ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                separator = {

                  right = "";
                  left = "";

                };
                padding = {
                  left = 1;
                  right = 1;
                };
              }
            ];
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

      snacks = {
        enable = true;
        settings = {
          terminal = {
            enable = true;
          };
          input = {
            enable = true;
          };
          image = {
            force = true;
          };
          gh = { };
          lazygit = { };
          picker = {
            sources = {
              gh_issue = { };
              gh_pr = { };
            };
          };
          dashboard = {
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
            ];
          };
        };
      };

      opencode = {
        enable = uopts.programs.opencode.enable;
      };

      nvim-tree = {
        enable = true;
        openOnSetup = false;
        settings = {
          respect_buf_cwd = true;
        };
      };

      web-devicons = {
        enable = true;
      };

      mini-icons = {
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

    globals = {
      mapleader = " ";
    };

    keymaps = [
      {
        key = "<leader>gg";
        action.__raw = "function() Snacks.lazygit() end";
        options = {
          desc = "Lazygit";
        };
      }
      {
        key = "<leader>gi";
        action.__raw = "function() Snacks.picker.gh_issue() end";
        options = {
          desc = "GitHub Issues (open)";
        };
      }
      {
        key = "<leader>gI";
        action.__raw = "function() Snacks.picker.gh_issue({ state = 'all' }) end";
        options = {
          desc = "GitHub Issues (all)";
        };
      }
      {
        key = "<leader>gp";
        action.__raw = "function() Snacks.picker.gh_pr() end";
        options = {
          desc = "GitHub Pull Requests (open)";
        };
      }
      {
        key = "<leader>gP";
        action.__raw = "function() Snacks.picker.gh_pr({ state = 'all' }) end";
        options = {
          desc = "GitHub Pull Requests (all)";
        };
      }
      {
        key = "<leader>no";
        action.__raw = "function() require('nvim-tree.api').tree.toggle() end";
        options = {
          desc = "Toggle nvim-tree";
        };
      }
      {
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files() end";
        options = {
          desc = "Find Files";
        };
      }
    ];
  };
}
