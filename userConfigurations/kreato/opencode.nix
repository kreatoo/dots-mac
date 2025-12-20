{ uopts, ... }: {
  programs.opencode = {
    enable = uopts.programs.opencode.enable;
    settings = {
      theme = "everforest";
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
      };
      permission = {
        bash = "ask";
      };
      provider = {
        vibeproxy-anthropic = {
          npm = "@ai-sdk/anthropic";
          name = "VibeProxy Anthropic";
          options = {
            apiKey = "NO-KEY-NEEDED-BUT-SOMETHING-NEEDS-TO-BE-HERE";
            baseURL = "http://localhost:8317/v1";
          };
          models = {
            gemini-claude-opus-4-5-thinking = {
              name = "Claude Opus 4.5 Thinking (Antigravity)";
              limit = {
                context = 128000;
                output = 64000;
              };
            };
            gemini-claude-sonnet-4-5 = {
              name = "Claude Sonnet 4.5 (Antigravity)";
              limit = {
                context = 128000;
                output = 64000;
              };
            };
            gemini-claude-sonnet-4-5-thinking = {
              name = "Claude Sonnet 4.5 Thinking (Antigravity)";
              limit = {
                context = 128000;
                output = 64000;
              };
            };
          };
        };
        vibeproxy-google = {
          npm = "@ai-sdk/google";
          name = "VibeProxy Google";
          options = {
            apiKey = "NO-KEY-NEEDED-BUT-SOMETHING-NEEDS-TO-BE-HERE";
            baseURL = "http://localhost:8317/v1beta";
          };
          models = {
            gemini-3-pro-image-preview = {
              name = "Gemini 3 Pro Image (Antigravity)";
              limit = {
                context = 109000;
                output = 64000;
              };
            };
            gemini-3-pro-preview = {
              name = "Gemini 3 Pro Preview (Antigravity)";
              limit = {
                context = 109000;
                output = 64000;
              };
            };
            gemini-3-flash = {
              name = "Gemini 3 Flash (Antigravity)";
              limit = {
                context = 109000;
                output = 64000;
              };
            };
          };
        };
        vibeproxy-openai = {
          npm = "@ai-sdk/openai-compatible";
          name = "VibeProxy OpenAI";
          options = {
            baseURL = "http://localhost:8317/v1";
          };
          models = {
            gpt-oss-120b-medium = {
              name = "GPT OSS 120b Medium (Antigravity)";
              limit = {
                context = 128000;
                output = 128000;
              };
            };
            raptor-mini = {
              name = "Raptor Mini (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
            };
          };
        };
      };
    };
  };
}
