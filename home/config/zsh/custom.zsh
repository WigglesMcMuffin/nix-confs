# =============================================================================
#                                Path Fixing
# =============================================================================

if [ -d "$HOME/programming/go" ]; then
  export GOPATH="$HOME/programming/go"
  export PATH="$GOPATH/bin:$PATH:/usr/local/go/bin"
fi
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d ${HOME}/.krew/bin ] && export PATH="$PATH:${HOME}/.krew/bin"
[ -d "/opt/chef-workstation/embedded/bin" ] && export PATH="/opt/chef-workstation/embedded/bin:$PATH"
if [ -d "/opt/chef-workstation/bin" ]; then
  export PATH="/opt/chef-workstation/bin:$PATH"
  eval "$(chef shell-init zsh)"
fi

# =============================================================================
#                                   Plugins
# =============================================================================

### Auto-complete
zstyle ':completion-sync:compinit:custom' enabled true
zstyle ':completion-sync:compinit:custom' command "source $(antidote path marlonrichert/zsh-autocomplete)"
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
zstyle ':autocomplete:*' delay 0.2

# =============================================================================
#                                Key Bindings
# =============================================================================

# Common CTRL bindings.
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line

# Do not require a space when attempting to tab-complete.
#bindkey "^i" expand-or-complete-prefix

# Fixes for alt-backspace and arrows keys
#bindkey '^[^?' backward-kill-word
#bindkey "^[[1;5C" forward-word
#bindkey "^[[1;5D" backward-word

bindkey -M viins \
    "^[p"   .history-search-backward \
    "^[n"   .history-search-forward \
    "^P"    .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "^N"    .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "^R"    .history-incremental-search-backward \
    "^S"    .history-incremental-search-forward \

#bindkey -M emacs \
#    "^[p"   .history-search-backward \
#    "^[n"   .history-search-forward \
#    "^P"    .up-line-or-history \
#    "^[OA"  .up-line-or-history \
#    "^[[A"  .up-line-or-history \
#    "^N"    .down-line-or-history \
#    "^[OB"  .down-line-or-history \
#    "^[[B"  .down-line-or-history \
#    "^R"    .history-incremental-search-backward \
#    "^S"    .history-incremental-search-forward \

bindkey -a \
    "^P"    .up-history \
    "^N"    .down-history \
    "k"     .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "j"     .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \
    "/"     .vi-history-search-backward \
    "?"     .vi-history-search-forward \

[ -n "${commands[fzf-share]}" ] && source "$(fzf-share)/key-bindings.zsh"
[ -n "${commands[fzf-share]}" ] && source "$(fzf-share)/completion.zsh"

bindkey '^I'              menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
