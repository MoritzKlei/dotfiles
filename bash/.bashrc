# ============================================================================
# Bash Configuration
# ============================================================================

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# -------- History Configuration --------
HISTCONTROL=ignoreboth                        # Ignore duplicates and lines starting with space
HISTSIZE=10000                                # Increased from 1000 for consistency with zsh
HISTFILESIZE=20000                            # Increased from 2000
shopt -s histappend                           # Append to history file

# -------- Shell Options --------
shopt -s checkwinsize                         # Update LINES and COLUMNS after each command
shopt -s globstar 2>/dev/null                 # Enable ** for recursive glob (bash 4.0+)

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

# -------- External Integrations --------
# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# Zoxide (cd replacement)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd bash)"

# envman (if installed)
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# -------- Colors --------
# Enable color support for ls and other tools
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# -------- Completion --------
# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# -------- Aliases --------
# Basic commands
alias vim='nvim'
alias c='clear'
alias ll='ls -lh'
alias la='ls -lAh'

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
# Source bash aliases if they exist
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

# Source local customizations if they exist
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
