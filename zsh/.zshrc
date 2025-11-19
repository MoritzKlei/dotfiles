# ============================================================================
# ZSH Configuration
# ============================================================================

# -------- History --------
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# -------- Keybindings --------
bindkey -e                                    # Emacs mode
bindkey '^p' history-search-backward          # Ctrl+P: previous command
bindkey '^n' history-search-forward           # Ctrl+N: next command
bindkey '^[w' kill-region                     # Alt+W: kill region

# -------- Completion System --------
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -------- Path Configuration --------
# Using a function to avoid duplicate path entries
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

add_to_path "/usr/local/go/bin"
add_to_path "$HOME/go/bin"
add_to_path "/opt/nvim-linux-x86_64/bin"
add_to_path "/usr/local/include"
add_to_path "/usr/local/lib/cmake"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.opencode/bin"

# -------- Plugins --------
[ -f "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

[ -f "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[ -f "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ] && \
  source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# -------- External Integrations --------
# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Zoxide (cd replacement)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

# Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# fzf key bindings and completion
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh

[ -f /usr/share/doc/fzf/examples/completion.zsh ] && \
  source /usr/share/doc/fzf/examples/completion.zsh

# -------- Aliases --------
# Basic commands
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# -------- Functions --------
# Git authentication
gitauth() {
  eval "$(ssh-agent)" && ssh-add "$HOME/.ssh/id_ed25519"
}

# Clone repo with submodules
gitsub() {
  if [ $# -lt 2 ]; then
    echo "Usage: gitsub <directory> <repo-url>"
    return 1
  fi
  git clone "$2" "$1" && cd "$1" && git submodule update --init --recursive
}

# -------- Local Customizations --------
# Source local customizations if they exist
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
