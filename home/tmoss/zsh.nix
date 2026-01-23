{ config, lib, pkgs, pkgs-stable, ... }:

{
  home = {
    packages = [
      pkgs.zsh
    ];

    file = {
      # ZSH files
      ".zshrc.custom".source = ../config/zsh/custom.zsh;
      ".p10k.zsh".source = ../config/zsh/p10k.zsh;
      ".zsh_aliases".source = ../config/zsh/aliases;
      ".zsh_functions".source = ../config/zsh/functions;
    };
  };

  programs = {
    zsh = {
      enable = true;
      initContent = let
        zshConfigEarly = lib.mkOrder 500 ''
          (( ''${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
          if ! pgrep -u "$USER" ssh-agent > /dev/null; then
              ssh-agent -t 4h > "$XDG_RUNTIME_DIR/ssh-agent.env"
          fi
          if [ ! -f "$SSH_AUTH_SOCK" ]; then
              source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
          fi

          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          # Nix
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
              . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi
        '';
        zshConfig = lib.mkOrder 1000 "source ~/.zshrc.custom";
        zshConfigStartup = lib.mkOrder 1500 ''
          # Load SSH and GPG agents via keychain.
          setup_agents() {
            [[ $UID -eq 0 ]] && return

            if which keychain &> /dev/null; then
              local -a ssh_keys gpg_keys
              for i in ~/.ssh/**/*pub; do test -f "$i(.N:r)" && ssh_keys+=("$i(.N:r)"); done
              gpg_keys=$(gpg -K --with-colons 2>/dev/null | awk -F : '$1 == "sec" { print $5 }')
              if (( $#ssh_keys > 0 )) || (( $#gpg_keys > 0 )); then
                alias run_agents='() { $(whence -p keychain) --quiet --eval --inherit any-once --agents ssh,gpg $ssh_keys ''${(f)gpg_keys} }'
                #[[ -t ''${fd:-0} || -p /dev/stdin ]] && eval `run_agents`
                unalias run_agents
              fi
            fi
          }

          setup_agents
          unfunction setup_agents

          # Source local zsh customizations.
          [[ -f ~/.zsh_rclocal ]] && source ~/.zsh_rclocal

          # Source functions and aliases.
          [[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
          [[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
          [[ -f ~/.zsh_aws ]] && source ~/.zsh_aws

          # vim: ft=zsh

          # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
      in lib.mkMerge [ zshConfigEarly zshConfig zshConfigStartup ];
      setOptions = [
        "autocd"                   # Allow changing directories without `cd`
        "append_history"           # Dont overwrite history
        "extended_history"         # Also record time and duration of commands.
        "share_history"            # Share history between multiple shells
        "hist_expire_dups_first"   # Clear duplicates when trimming internal hist.
        "hist_find_no_dups"        # Dont display duplicates during searches.
        "hist_ignore_dups"         # Ignore consecutive duplicates.
        "hist_ignore_all_dups"     # Remember only one unique copy of the command.
        "hist_reduce_blanks"       # Remove superfluous blanks.
        "hist_save_no_dups"        # Omit older commands in favor of newer ones.

        # Changing directories
        "pushd_ignore_dups"        # Dont push copies of the same dir on stack.
        "pushd_minus"              # Reference stack entries with "-".

        "extended_glob"
      ];

      envExtra = "skip_global_compinit=1\n";

      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
          "ohmyzsh/ohmyzsh path:plugins/eza"
          "zpm-zsh/colors"
          "zpm-zsh/colorize"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting kind:defer"
          # You should use
          "MichaelAquilina/zsh-you-should-use"
          # Enhanced cd
          "b4b4r07/enhancd kind:defer"
          # TODO: Outdated, figure out docker approved solution
          # Docker completion
          #"felixr/docker-zsh-completion"
          # Taskfile completion
          "sawadashota/go-task-completions kind:fpath"
          # Simple zsh calculator
          "arzzen/calc.plugin.zsh"
          # ZSH completions for direnv
          "BronzeDeer/zsh-completion-sync"
          # Directory colors
          # "seebi/dircolors-solarized", ignore:"*", as:plugin
          "romkatv/powerlevel10k"
          "marlonrichert/zsh-autocomplete"
        ];

      };
      enableCompletion = false;
      completionInit = "";
    };

  };
}
