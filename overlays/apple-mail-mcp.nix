final: prev: let
  selectolax-0_4_8 = prev.python3Packages.selectolax.overrideAttrs (old: {
    version = "0.4.8";
    src = final.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/s/selectolax/selectolax-0.4.8.tar.gz";
      hash = "sha256-zXAxZbmjRr4lXiyltCGeAQCZEZd6yKR02My34y6aT64=";
    };
  });
in {
  apple-mail-mcp = final.python3Packages.buildPythonApplication {
    pname = "apple-mail-mcp";
    version = "0.3.2";
    pyproject = true;

    src = final.fetchurl {
      url = "https://files.pythonhosted.org/packages/ac/13/12a7bdb1c8fab711e9726b2978d8a52b6638ae2b64612809c6cb1f967750/apple_mail_mcp-0.3.2.tar.gz";
      hash = "sha256-2nxRt+uWygdou4dNuq27U5pCI6Zhra8LmpfcqzNlJxA=";
    };

    build-system = [ final.python3Packages.hatchling ];

    dependencies = with final.python3Packages; [
      fastmcp
      cyclopts
      beautifulsoup4
      selectolax-0_4_8
      watchfiles
    ];

    pythonImportsCheck = [ "apple_mail_mcp" ];

    meta = {
      description = "Apple Mail MCP server with full-coverage FTS5 body search";
      homepage = "https://github.com/imdinu/apple-mail-mcp";
      license = final.lib.licenses.gpl3Only;
      platforms = final.lib.platforms.darwin;
      mainProgram = "apple-mail-mcp";
    };
  };
}
