{
  pkgs,
  lib,
  uopts,
  config,
  systemName,
  ...
}:
let
  mkIf = lib.mkIf;

  pi-wrapped = pkgs.writeShellScriptBin "pi" ''
    export GITHUB_TOKEN="$(cat "$HOME/.config/opencode/github-pat" 2>/dev/null || echo "")"
    exec ${pkgs.llm-agents.pi}/bin/pi "$@"
  '';

  command-code-models = [
    {
      id = "deepseek/deepseek-v4-pro";
      name = "DeepSeek V4 Pro";
      contextWindow = 1000000;
      maxTokens = 131072;
    }
    {
      id = "deepseek/deepseek-v4-flash";
      name = "DeepSeek V4 Flash";
      contextWindow = 1000000;
      maxTokens = 131072;
    }
    {
      id = "MiniMaxAI/MiniMax-M3";
      name = "MiniMax M3";
      contextWindow = 1000000;
      maxTokens = 131072;
    }
    {
      id = "glm-5.2";
      name = "GLM 5.2";
      contextWindow = 1048576;
      maxTokens = 131072;
    }
  ];

  common-mcp-servers = {
    context7 = {
      url = "https://mcp.context7.com/mcp";
    };
    gh_grep = {
      url = "https://mcp.grep.app";
    };
    exa = {
      url = "https://mcp.exa.ai/mcp";
    };
    github = {
      url = "https://api.githubcopilot.com/mcp/";
      auth = "bearer";
      bearerTokenEnv = "GITHUB_TOKEN";
    };
  };

  work-mcp-servers = {
    atlassian = {
      url = "https://mcp.atlassian.com/v1/mcp/authv2";
    };
    slack = {
      url = "https://mcp.slack.com/mcp";
    };
    mail = {
      command = "apple-mail-mcp";
    };
  };

  home-mcp-servers = {
    megaten_fusion = {
      command = "bun";
      args = [ "x" "megaten-fusion-mcp" ];
    };
  };

  mcpServers = common-mcp-servers
    // lib.optionalAttrs (systemName == "work") work-mcp-servers
    // lib.optionalAttrs (systemName != "work") home-mcp-servers;

  crof-libre-models = [
    {
      id = "deepseek-v4-pro";
      name = "DeepSeek V4 Pro";
      contextWindow = 1000000;
      maxTokens = 131072;
    }
    {
      id = "deepseek-v4-pro-precision";
      name = "DeepSeek V4 Pro Precision";
      contextWindow = 1000000;
      maxTokens = 131072;
    }
    {
      id = "glm-5.1";
      name = "GLM 5.1";
      contextWindow = 202752;
      maxTokens = 202752;
    }
  ];
in
mkIf uopts.programs.pi.enable {
  home.packages = [ pi-wrapped ];

  home.file.".pi/agent/settings.json" = {
    text = builtins.toJSON {
      defaultProvider = "command-code";
      defaultModel = "deepseek/deepseek-v4-pro";
      defaultThinkingLevel = "medium";
      theme = "dark";
      packages = [
        "npm:@tintinweb/pi-subagents"
        "npm:pi-zentui"
        "npm:@narumitw/pi-retry"
        "git:github.com/jonjonrankin/pi-caveman"
        "npm:pi-rewind"
        "npm:pi-web-access"
        "npm:pi-mcp-adapter"
        "npm:@gotgenes/pi-permission-system"
      ];
      compaction = {
        enabled = true;
        reserveTokens = 16384;
        keepRecentTokens = 20000;
      };
      retry = {
        enabled = true;
        maxRetries = 3;
      };
    };
  };

  home.file.".pi/agent/mcp.json" = {
    text = builtins.toJSON {
      inherit mcpServers;
    };
  };

  home.file.".pi/agent/models.json" = {
    text = builtins.toJSON {
      providers = {
        crof-libre = {
          name = "CroF (Libre Turks)";
          baseUrl = "https://crof.ai/v1";
          api = "openai-completions";
          authHeader = true;
          apiKey = "!cat ${config.home.homeDirectory}/.config/opencode/crof-api-key-libreturks";
          models = crof-libre-models;
        };
        command-code = {
          name = "Command Code";
          baseUrl = "http://127.0.0.1:8082/v1";
          api = "openai-completions";
          authHeader = true;
          apiKey = "!cat ${config.home.homeDirectory}/.config/opencode/commandcode-api-key";
          models = command-code-models;
        };
        zai = {
          models = [
            {
              id = "glm-5.2";
              name = "GLM 5.2";
              contextWindow = 1048576;
              maxTokens = 131072;
            }
          ];
        };
        opencode-go = {
          models = [
            {
              id = "glm-5.2";
              name = "GLM 5.2";
              contextWindow = 1048576;
              maxTokens = 131072;
            }
          ];
        };
      };
    };
  };

  home.file.".pi/agent/extensions/pi-permission-system/config.json" = {
    text = builtins.toJSON {
      permission = {
        "*" = "ask";
        path = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
          "*.env.example" = "allow";
        };
        bash = {
          "grep *" = "allow";
          "rg *" = "allow";
          "find *" = "allow";
          "ls *" = "allow";
          "rm -rf *" = "deny";
          "sudo *" = "ask";
        };
        external_directory = "ask";
      };
    };
  };
}
