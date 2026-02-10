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

      # For telescope
      fzf

      # Lua LSP
      lua5_1
      lua-language-server
      luarocks

      #Go lang
      go
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
  home = let
    dotfiles = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."dotfiles".path;
  in {

    mutableFile = {
      "dotfiles" = {
        url = https://github.com/wigglesmcmuffin/dotfiles.git;
        type = "git";
      };
    };

    file = {
      ".config/nvim/lazy-lock.json".source = "${dotfiles}/nvim/lazy.lock";
      ".config/nvim/lua".source = "${dotfiles}/nvim/lua";
    };
  };
}
