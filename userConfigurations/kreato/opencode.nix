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
in
{
  programs.opencode = {
    enable = uopts.programs.opencode.enable;
    enableMcpIntegration = true;
    package = pkgs.opencode;
    settings = {
      theme = "ayu-dark";
      plugin = [
        "opencode-antigravity-auth@latest"
        "@slkiser/opencode-quota"
        "yet-another-opencode-cursor-auth@latest"
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
            antigravity-gemini-3-pro = {
              name = "Gemini 3 Pro (Antigravity)";
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
            antigravity-claude-sonnet-4-5 = {
              name = "Claude Sonnet 4.5 (Antigravity)";
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
            antigravity-claude-sonnet-4-5-thinking = {
              name = "Claude Sonnet 4.5 Thinking (Antigravity)";
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
