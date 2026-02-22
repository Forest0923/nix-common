{
  programs.opencode = {
    enable = true;
  };

  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    provider = {
      lmstudio = {
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "https://evox2.home/v1";
        };
        models = {
          "qwen/qwen3-coder-next" = {
            name = "Qwen3 Coder Next";
            tools = true;
          };
          "zai-org/glm-4.7-flash" = {
            name = "GLM 4.7 Flash";
            tools = true;
          };
        };
      };
    };
    model = "lmstudio/qwen/qwen3-coder-next";
  };
}
