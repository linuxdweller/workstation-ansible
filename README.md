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
activate it and install Galaxy requirements:

```
cd ../playbook
poetry install
poetry shell
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
activate it and install Galaxy requirements:

```
cd ../playbook
poetry install
poetry shell
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
activate it and install Galaxy requirements:

```
cd playbook
poetry install
poetry shell
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

## Gotchas

Quirks you might need to work around.

- To apply `tmux` configuration, hit `C-b I`.
- `docker` role does not run on WSL because in WSL Docker is managed by Docker Desktop on Windows.
- `gopls`, `goimport` are not installed automatically.
  Run `go install golang.org/x/tools/gopls@latest` and `go install golang.org/x/tools/cmd/goimports@latest`.
- The playbook has changed a lot over time, run `clean.yaml` playbook before `main.yaml` on previously
  configured machines for best results.

## Updating NeoVim Plugins

To update NeoVim plugins, use `lazy.nvim` and copy the updated lockfile to the `neovim` role:

```
cp ~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```

Or use `scp` to copy the lockfile from remote machine:

```
scp stirring-octopus@192.168.0.184:~/.config/nvim/lazy-lock.json playbook/roles/neovim/files
```
