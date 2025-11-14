# -------- History --------
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# -------- Keybindings --------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# -------- Completion system --------
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -------- Path --------
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/usr/local/include"
export PATH="$PATH:/usr/local/lib/cmake"

# Created by `pipx` on 2025-09-12 09:19:52
export PATH="$PATH:/home/mkl/.local/bin"

# -------- Plugins --------
# (clone into $HOME/.zsh/plugins/ or add as submodules to dotfiles)
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# -------- Integrations --------
. "$HOME/.cargo/env"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# -------- fzf integration --------
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# -------- Aliases --------
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

alias wingit="/mnt/c/IT/utils/PortableGit/bin/git.exe"
alias gimme="sudo chown -R $USER:$USER"
alias rmbuild="rm ./build -rf && mkdir build"
gitauth()  {
  eval $(ssh-agent) && ssh-add $HOME/.ssh/id_ed25519
}
gitsub() {
  git clone $2 $1 && cd $1 && git submodule update --init --recursive
}
wingitsub() {
  wingit clone $2 $1 && cd $1 && wingit submodule update --init --recursive && gimme . && gimme .git
}
cninja() {
  cmake -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ $1
}
pwsh() {
    pwsh.exe -wd "${1:-C:/Users/u4032606/}"
}

# -------- opencode -------- 
export PATH=/home/mkl/.opencode/bin:$PATH

# -------- Getinge -------- 
export NODE_EXTRA_CA_CERTS=/usr/share/ca-certificates/extra/ZscalerRootCert.crt
