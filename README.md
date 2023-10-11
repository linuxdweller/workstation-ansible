Ansible playbook setting up my development environment on Ubuntu (22.04).

Why not manage dotfiles like everyone else?
* Dotfiles are only configuration, they do not manage software installation.
* Most solutions use shell scripts while I prefer Ansible's declarative style.
* Ansible handles encryption of secrets.
* I like Ansible.

## Roles

* `docker`: Latest Docker and Docker Compose are installed.
* `go`: Golang is installed.
* `hashicorp`: Latest Terraform and Packer are installed.
* `helm`: Latest Helm is installed.
* `k3d`: Latest K3d is installed.
* `kubectl`: Latest kubectl is installed.
* `neovim`: Latest NeoVim is installed and configured.
* `ohmyzsh`: Oh My Zsh is installed and configured, along with useful utilities.
* `tmux`: tmux is installed and configured.

## Usage

The playbook works best on Ubuntu 22.04.
It is recommended to use an Ubuntu 22.04 server VM.
Docker is not configured on WSL or Ubuntu 20.04.

```
ansible-playbook --ask-become-pass main.yaml
```

Enter your `sudo` password in the prompt.

After Ansible is done running:

* Open `tmux` and hit `Ctrl-b I`.

The development environment should be all set up.

## Gotchas

Quirks you might need to work around.

* To apply `tmux` configuration, hit `C-b I`.
* `docker` role does not run on WSL because in WSL Docker is managed by Docker Desktop on Windows.

## Updating NeoVim Plugins

To update NeoVim plugins, use `lazy.nvim` and copy the updated lockfile to the `neovim` role:

```
cp ~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```

Or use `scp` to copy the lockfile from remote machine:

```
scp stirring-octopus@192.168.0.184:~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```
