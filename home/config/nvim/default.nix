{
  pkgs,
  globals,
  config,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      tree-sitter
      gcc

      # Lua LSP
      lua5_1
      lua-language-server
      luarocks

      #Go lang
      gopls

      #Python
      ruff
      python313Packages.python-lsp-server
      python313Packages.python-lsp-ruff
      pyright
    ];

    plugins = [pkgs.vimPlugins.lazy-nvim];

    extraLuaConfig = ''require("tmoss")'';
  };

  home.file.".config/nvim/lazy-lock.json".source = ./lazy.lock;
  home.file.".config/nvim/lua".source = ./lua;
}
