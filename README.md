Ansible playbook setting up my development environment on:

- Debian 11
- Debian 12
- Ubuntu 22.04

Why not manage dotfiles like everyone else?

- Dotfiles are only configuration, they do not manage software installation.
- Most solutions use shell scripts while I prefer Ansible's declarative style.
- Ansible handles encryption of secrets.
- I like Ansible.

## Roles

- `docker`: Latest Docker and Docker Compose are installed.
- `go`: Golang is installed.
- `hashicorp`: Latest Terraform and Packer are installed.
- `helm`: Latest Helm is installed.
- `k3d`: Latest K3d is installed.
- `kubectl`: Latest kubectl is installed.
- `neovim`: Latest NeoVim is installed and configured.
- `ohmyzsh`: Oh My Zsh is installed and configured, along with useful utilities.
- `tmux`: tmux is installed and configured.

## Usage

### How-To Manage Machine with GitLab State

Set environment variables to configure Terraform to use GitLab managed state.
It is recommended to do so with the following `.env` snippet:

```bash
# Inside .env
# Authentication details for GitLab managed Terraform state.
export GITLAB_USER='Lior'
# Full api access is required, just read_repository and write_repository are not enough.
export GITLAB_TOKEN='glpat-xxxxxxxxxxxxxxxxxxxx'

# Immitating CI environment variables.
export CI_PROJECT_ID='35'
export CI_API_V4_URL='https://git.houseofkummer.com/api/v4'
export CI_ENVIRONMENT_NAME='workstation'

# Terraform state configuration.
export TF_HTTP_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/${CI_ENVIRONMENT_NAME}"
export TF_HTTP_LOCK_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/${CI_ENVIRONMENT_NAME}/lock"
export TF_HTTP_LOCK_METHOD='POST'
export TF_HTTP_UNLOCK_ADDRESS="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/${CI_ENVIRONMENT_NAME}/lock"
export TF_HTTP_UNLOCK_METHOD='DELETE'
export TF_HTTP_USERNAME="${GITLAB_USER}"
export TF_HTTP_PASSWORD="${GITLAB_TOKEN}"
```

Go to `terraform` directory, initialize Terraform and apply the module:

```
cd terraform
terraform init
terraform apply
```

Go to `playbook` directory, install dependencies in a virtual environment,
and install Galaxy requirements:

```
cd ../playbook
python3 -m venv .venv
source .venv/bin/activate
pip install --requirement requirements.txt
ansible-galaxy collection install --requirements requirements.yaml
```

Run `main.yaml` playbook:

```
ansible-playbook --inventory=inventory main.yaml
```

The development environment should be all set up.
[Check out the Gotchas section for further setup instructions.](#gotchas)

### How-To Create Machine with Local State

Change configurations to use local Terraform state:

```
sed 's/lkummer\.homelab\.terraform_http/lkummer\.homelab\.terraform_local/' -i playbook/inventory/workstation.yaml
echo 'tfstate_path: ../terraform/terraform.tfstate' >> playbook/inventory/workstation.yaml
sed '/backend "http" {}/d' -i terraform/versions.tf
```

Go to `terraform` directory, initialize Terraform and apply the module:

```
cd terraform
terraform init
terraform apply
```

Go to `playbook` directory, install dependencies in a virtual environment,
and install Galaxy requirements:

```
cd ../playbook
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install --requirement requirements.txt
ansible-galaxy collection install --requirements requirements.yaml
```

Run `main.yaml` playbook:

```
ansible-playbook --inventory=inventory main.yaml
```

The development environment should be all set up.
[Check out the Gotchas section for further setup instructions.](#gotchas)

### How-To Apply To Local Machine

The playbook works best on Ubuntu 22.04 and Debian 12.
It is recommended to use a Debian 12 VM.

Change playbook hosts to `localhost`:

```
sed 's/hosts: workstation/hosts: localhost/' -i playbook/main.yaml
```

Go to `playbook` directory, install dependencies in a virtual environment,
and install Galaxy requirements:

```
cd ../playbook
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install --requirement requirements.txt
ansible-galaxy collection install --requirements requirements.yaml
```

Run `clean.yaml` playbook to perform cleanups from old versions of the playbook:

```
ansible-playbook --ask-become-pass clean.yaml
```

Run `main.yaml` playbook:

```
ansible-playbook --ask-become-pass main.yaml
```

The development environment should be all set up.
[Check out the Gotchas section for further setup instructions.](#gotchas)

### How-To Add Updated NeoVim Plugins Lockfile

To update NeoVim plugins, use `lazy.nvim` and copy the updated lockfile to the `neovim` role:

```
cp ~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```

Or use `scp` to copy the lockfile from remote machine:

```
scp stirring-octopus@192.168.0.184:~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```

You can now commit the updated lockfile to the repository.

### How-To Upgrade From Debian 11 to 12

If you still have pets that can not be easily re-imaged you can use the following
commands to upgrade from Debian 11 to 12.

[See official documentation on upgrading](https://wiki.debian.org/DebianUpgrade)
before going through the process.

Make sure your system is fully updated on the older release:

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get full-upgrade
```

Change system repositories to `bookworm`:

```
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
```

You also need to update repositories you manage.
If you only use this playbook to manage your system, you can remove user defined
repositories and run the playbook after the upgrade finished.

```
rm /etc/apt/sources.list.d/*.list
```

Perform the upgrade:
**DO NOT INTERRUPT THESE COMMANDS**

```
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade
sudo apt-get full-upgrade
```

Restart your system, when running `cat /etc/issue` it should say Debian 12.
It is recommended to apply the playbook now. You may need to perform some
bootstrapping steps again.

### How-To Bootstrap On New Machine

Installing global packages with `pip` on Debian may break system packages.
This playbook both requires Poetry and manages Poetry with `pipx`, making it tricky
to bootstrap on a brand new installation.

Use the following commands to manually install `pipx` and Poetry:

```
sudo apt-get update
sudo apt-get install python3-venv
python3 -m venv .venv
```

Now you can install dependencies as usual:

```
cd playbook
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install --requirement requirements.txt
ansible-galaxy collection install --requirements requirements.yaml
```

You are now ready to run the playbook on your new machine.

### How-To Set Gnome Terminal Theme

[Use Catppuccin Gnome Terminal theme.](https://github.com/catppuccin/gnome-terminal)
In particular, use the Macchiato flavor.

Run the following command:
**Make sure to verify the content of the link before running!**
It is a short Python script.

```
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -
```

You should see profiles for the theme in Gnome Terminal.

## Gotchas

Quirks you might need to work around.

- To apply `tmux` configuration, hit `C-b I`.
- `docker` role does not run on WSL because in WSL Docker is managed by Docker Desktop on Windows.
- `gopls`, `goimport` are not installed automatically.
  Run `go install golang.org/x/tools/gopls@latest` and `go install golang.org/x/tools/cmd/goimports@latest`.
- The playbook has changed a lot over time, run `clean.yaml` playbook before `main.yaml` on previously
  configured machines for best results.
