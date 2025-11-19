# Dotfiles

My personal dotfiles managed with GNU Stow and Ansible.

## Quick Start with ansible-pull (for fresh systems)

### First-time setup on a new system:

```bash
# Install ansible
sudo apt update
sudo apt install -y ansible
```

### Running with sudo password (needed):

```bash
ansible-pull -U https://github.com/MoritzKlei/dotfiles.git playbook.yaml --ask-become-pass
```

## Deploy to Remote Servers with Inventory

### Setup:

1. Create an inventory file (not tracked in git):
```bash
cd ~/dotfiles
cp inventory.example inventory
# Edit inventory with your server details
vim inventory
```

2. Deploy to all servers in inventory:
```bash
ansible-playbook -i inventory playbook.yaml --ask-become-pass
```

3. Deploy to specific group:
```bash
ansible-playbook -i inventory playbook.yaml --limit webservers --ask-become-pass
```

4. Deploy to specific host:
```bash
ansible-playbook -i inventory playbook.yaml --limit web1 --ask-become-pass
```

### Example inventory file:

```ini
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=mkl
web2 ansible_host=192.168.1.11 ansible_user=mkl

[databases]
db1 ansible_host=192.168.1.20 ansible_user=mkl

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

## Update Existing Dotfiles Setup

```bash
cd ~/dotfiles
git pull
ansible-playbook playbook.yaml
```

## What gets installed

### System packages (apt)
- Development tools: build-essential, clang, cmake, ninja
- Languages: Go, Rust, Python3, Java, Lua
- CLI tools: tmux, zsh, fzf, stow, btop, ripgrep, fd-find

### Rust tools (cargo)
- ripgrep - Fast grep alternative
- fd-find - Fast find alternative  
- eza - Modern ls replacement
- starship - Cross-shell prompt
- zoxide - Smart cd command

### Go tools
- lazygit - Terminal UI for git
- lazydocker - Terminal UI for docker

### Applications
- Neovim (latest) - Text editor
- Docker - Container platform

## Structure

```
dotfiles/
├── bash/              # Bash configuration (.bashrc)
├── zsh/               # Zsh configuration (.zshrc and plugins)
├── nvim/              # Neovim configuration (LazyVim)
├── tmux/              # Tmux configuration (.tmux.conf and TPM)
├── starship/          # Starship prompt configuration
├── playbook.yaml      # Ansible playbook for setup
├── inventory.example  # Example inventory file
└── README.md          # This file
```

## How It Works

### ansible-pull mode (fresh system):
1. Ansible clones this repo to a temp directory
2. Detects it's running from the cloned repo
3. Initializes all git submodules
4. Installs packages and tools
5. Stows configs to your home directory

### ansible-playbook mode (with inventory):
1. Connects to remote servers via SSH
2. Clones dotfiles repo to `~/dotfiles` on each server
3. Initializes submodules
4. Installs packages and tools
5. Stows configs to user home directory

### Config file handling:
- Existing config files (`.bashrc`, `.zshrc`, etc.) are **removed** (not backed up)
- Stow creates symlinks from `~/dotfiles/<package>` to `~/`
- If config is already a symlink, it's left alone

## Manual Stow Usage

```bash
# Link a specific config
stow -t ~ bash

# Unlink a config
stow -D -t ~ bash

# Restow (useful after updates)
stow -R -t ~ bash
```

## Notes

- **Existing configs are deleted** - make sure to backup manually if needed
- The playbook is idempotent - safe to run multiple times
- Default shell will be changed to zsh
- User will be added to docker group (requires logout/login to take effect)
- Inventory files are gitignored for security (use `inventory.example` as template)

## SSH Key Setup for Remote Servers

Before deploying to remote servers, ensure:

1. SSH keys are set up:
```bash
ssh-copy-id user@remote-server
```

2. You can connect without password:
```bash
ssh user@remote-server
```

3. The remote user has sudo privileges
