Ansible playbook setting up my development environment on Ubuntu (20.04).

Why not manage dotfiles like everyone else?
* Dotfiles are only configuration, they do not manage software installation.
* Most solutions use shell scripts while I prefer Ansible's declarative style.
* Ansible handles encryption of secrets.
* I like Ansible.

Roles:
* `hashicorp`: Latest Terraform and Packer are installed.
* `helm`: Latest Helm is installed.
* `docker`: Latest Docker and Docker Compose are installed.
* `k3d`: Latest K3d is installed.
* `kubectl`: Latest kubectl is installed.
* `neovim`: Latest NeoVim is installed and configured.
* `ohmyzsh`: Oh My Zsh is installed and configured, along with useful utilities.
* `tmux`: tmux is installed and configured.

Gotchas:
* To apply NeoVim configuration, run `:PackerSync`.
* To apply `tmux` configuration, hit `C-b I`.
* `docker` role does not run on WSL because in WSL Docker is managed by Docker Desktop on Windows.
* Dependencies for Go and TS completion in NeoVim are not installed. [TS language server installation instructions](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver). Go completion requires `gopls`.
