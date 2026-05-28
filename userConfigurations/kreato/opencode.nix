{
  pkgs,
  lib,
  uopts,
  ...
}:
let
  ayu-dark-theme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/postrednik/opencode-ayu-theme/main/.opencode/themes/ayu-dark.json";
    sha256 = "00fd1c8vm7pljsy3xjv3nx3lpjpynja2799wn9g0xi1dqprwg7j7";
  };

  commandcode-models-json = builtins.fromJSON (builtins.readFile (builtins.fetchurl {
    url = "http://127.0.0.1:8082/v1/models";
    sha256 = "0a3s4nin7wm8883xafdsfr9yd55zby6msy4dagirc9ayi5zbvj0r";
  }));

  commandcode-models = builtins.listToAttrs (map (model: {
    name = model.id;
    value = {
      name = model.name;
      limit = {
        context = if model.context_length != null then model.context_length else 128000;
        output = 16384;
      };
      modalities = {
        input = [ "text" ];
        output = [ "text" ];
      };
    };
  }) commandcode-models-json.data);
in
{
  programs.opencode = {
    enable = uopts.programs.opencode.enable;
    enableMcpIntegration = true;
    package = pkgs.opencode;
    tui = {
      theme = "ayu-dark";
    };
    settings = {
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git"
        "@tarquinen/opencode-dcp@latest"
        "cc-safety-net"
      ];
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        gh_grep = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp";
          enabled = true;
        };
      };
      permission = {
        bash = "ask";
      };
      provider = {
        cursor = {
          name = "Cursor";
        };
        nano-gpt = {
          models = {
            "minimax/minimax-m2.7" = {
              name = "Minimax M2.7";
              limit = {
                context = 204800;
                output = 65536;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
            "deepseek/deepseek-v4-pro-cheaper:thinking" = {
              name = "DeepSeek V4 Pro Cheaper (Thinking)";
              limit = {
                context = 1000000;
                output = 384000;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
          };
        };
        google = {
          models = {
            gemini-3-pro-low = {
              name = "Gemini 3 Pro Low (CLI)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            gemini-3-pro-high = {
              name = "Gemini 3 Pro High (CLI)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            gemini-3-flash = {
              name = "Gemini 3 Flash (CLI)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            gemini-3-flash-preview = {
              name = "Gemini 3 Flash Preview (CLI)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            gemini-3-pro-preview = {
              name = "Gemini 3 Pro Preview (CLI)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            "antigravity-gemini-3.1-pro" = {
              name = "Gemini 3.1 Pro (Antigravity)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
              variants = {
                low = {
                  thinkingLevel = "low";
                };
                high = {
                  thinkingLevel = "high";
                };
              };
            };
            antigravity-gemini-3-flash = {
              name = "Gemini 3 Flash (Antigravity)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
              variants = {
                minimal = {
                  thinkingLevel = "minimal";
                };
                low = {
                  thinkingLevel = "low";
                };
                medium = {
                  thinkingLevel = "medium";
                };
                high = {
                  thinkingLevel = "high";
                };
              };
            };
            antigravity-claude-sonnet-4-6 = {
              name = "Claude Sonnet 4.6 (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            antigravity-claude-opus-4-6-thinking = {
              name = "Claude Opus 4.6 Thinking (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
              variants = {
                low = {
                  thinkingConfig = {
                    thinkingBudget = 8192;
                  };
                };
                max = {
                  thinkingConfig = {
                    thinkingBudget = 32768;
                  };
                };
              };
            };
          };
        };
        crof = {
          name = "Crof";
          models = {
            "deepseek-v4-pro" = {
              name = "DeepSeek V4 Pro";
              limit = {
                context = 1000000;
                output = 131072;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
            "glm-5.1" = {
              name = "GLM 5.1";
              limit = {
                context = 202752;
                output = 202752;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
            "kimi-k2.5-lightning" = {
              name = "Kimi K2.5 Lightning";
              limit = {
                context = 131072;
                output = 32768;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
          };
          options = {
            baseURL = "https://crof.ai/v1";
            apiKey = "{file:~/.config/opencode/crof-api-key}";
          };
        };
        crof-libre = {
          name = "Crof (Libre Turks)";
          models = {
            "deepseek-v4-pro" = {
              name = "DeepSeek V4 Pro";
              limit = {
                context = 1000000;
                output = 131072;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
            "deepseek-v4-pro-precision" = {
              name = "DeepSeek V4 Pro Precision";
              limit = {
                context = 1000000;
                output = 131072;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
            "glm-5.1" = {
              name = "GLM 5.1";
              limit = {
                context = 202752;
                output = 202752;
              };
              modalities = {
                input = [ "text" ];
                output = [ "text" ];
              };
            };
          };
          options = {
            baseURL = "https://crof.ai/v1";
            apiKey = "{file:~/.config/opencode/crof-api-key-libreturks}";
          };
        };
        commandcode = {
          name = "CommandCode";
          models = commandcode-models;
          options = {
            baseURL = "http://127.0.0.1:8082/v1";
            apiKey = "{file:~/.config/opencode/commandcode-api-key}";
          };
        };
      };
    };
  };

  home.file.".opencode/antigravity.json" = lib.mkIf uopts.programs.opencode.enable {
    text = builtins.toJSON {
      quota_fallback = true;
      pid_offset_enabled = true;
      account_selection_strategy = "hybrid";
      quiet_mode = true;
    };
  };

  home.file.".opencode/themes/ayu-dark.json" = lib.mkIf uopts.programs.opencode.enable {
    source = ayu-dark-theme;
  };

  home.file.".config/opencode/plugin/terminal-bell.ts" = lib.mkIf uopts.programs.opencode.enable {
    text = ''
      import type { Plugin } from "@opencode-ai/plugin"

      export const TerminalBell: Plugin = async ({ project, client, $, directory, worktree }) => {
        return {
          event: async ({ event }) => {
            if (event.type === "session.idle") {
              await Bun.write(Bun.stdout, "\x07")
            }
          }
        }
      }
    '';
  };
}
