## Bitwarden Zsh Plugin

Plugin for integrating Bitwarden into the shell user experience.

## Tutorial

Detailed walkthrough of setup and basic usage example.

### Setup

1. [Install Bitwarden CLI](https://bitwarden.com/help/cli/#download-and-install)
1. Set Git `user.signingKey` config option to your public key
1. Copy this plugin to `~/.oh-my-zsh/custom/plugins`
1. Enable the plugin by adding `plugins+=(bitwarden)` to `~/.zshrc` (before `source $ZSH/oh-my-zsh`)
1. Set which secret note to use for your SSH key by setting `export BITWARDEN_SSH_KEY_NOTE_ID='...'`
1. `source ~/.zshrc`

Your `~/.zshrc` should look something like this:

```sh
# Inside ~/.zshrc

# Set to ID of secret note containing SSH private key for bw-ssh-add command.
export BITWARDEN_SSH_KEY_NOTE_ID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
plugins+=(bitwarden)

# ...
source $ZSH/oh-my-zsh.sh
```

### Trying it out

Run the following command to add your key to SSH agent.
Input your master password when prompted.

```sh
bwsa
```

List keys in SSH agent and make sure your key was added:

```sh
ssh-add -L
```

## Guides

### How-to add SSH key

Run the following command and input your master password when prompted.

```sh
bwsa
```

Your SSH key is now added to SSH agent.

### How-to setup new SSH key

Unlock your vault:

```sh
export BW_SESSION="$(bw unlock --raw)"
```

Generate new SSH key.
Leave the passphrase empty.
In this guide we will name our key file `example`.

```sh
ssh-keygen -t ed25519 -f example
```

Create a secret note with the private key file content.
In this guide we will name our note `Example SSH Key`.

```sh
bw get template item | jq '.name="Example SSH Key" | .type=2 | .secureNote.type=0' | jq ".notes=\"$(cat example)\"" | bw encode | bw create item
```

When the above command succeeds, the `id` key in the output contains the note ID.
Copy the note ID and add the following line to your `~/.zshrc`:

```sh
# Inside .zshrc
# Replace the placeholder with your note id.
export BITWARDEN_SSH_KEY_NOTE_ID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

Set your Git signing key:

```
git config --global user.signingKey "$(cat example.pub)"
```

You should be all ready to use your new SSH key.

### How-to find id of note

Unlock your vault:

```sh
export BW_SESSION="$(bw unlock --raw)"
```

Search for items, the following command searches for items containing `SSH` in
their title:

```sh
bw list items --search 'SSH' | jq '.[] | {name, id}'
```

The output should look like this:

```
{
  "name": "Personal SSH key",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
{
  "name": "Work SSH key",
  "id": "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
}
```

You can see the ID of items matching your search.

```sh
export BITWARDEN_SSH_KEY_NOTE_ID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
```

## Reference

List of all available commands and aliases.

### `bw-ssh-add`

Adds SSH key stored in Bitwarden secret note.

Additional aliases:

- `bw-ssh`
- `bwsa`

Requires:

- `BITWARDEN_SSH_KEY_NOTE_ID` containing note ID with SSH private key
