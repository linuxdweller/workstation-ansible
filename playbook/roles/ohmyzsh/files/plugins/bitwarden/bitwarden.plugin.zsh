alias bw-ssh=bw-ssh-add
alias bwsa=bw-ssh-add

bw-ssh-add() {
	# Check note ID environment variable is present.
	if [[ -v BITWARDEN_SSH_KEY_NOTE_ID ]]
	then
	else
		echo '\e[0;31m!\e[0m BITWARDEN_SSH_KEY_NOTE_ID environment variable is not set'
		echo '  \e[0;37mSet it by adding the following line to your `~/.zshrc`'
		echo '  \e[0;37mReplace the placeholder value with the ID of a Bitwarden secret note containing an SSH private key.'
		echo "  \e[0;37m  export BITWARDEN_SSH_KEY_NOTE_ID='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'"
		return 1
	fi

	# Get public key from Git config.
	if signing_pubkey="$(git config --global --get user.signingkey)";
	then;
	else;
		echo '\e[0;31m!\e[0m user.signingkey Git config option is not set'
		echo '  \e[0;37mGit can not sign commits without known what key to use.'
		return 1
	fi

	# Check if key is already present in ssh agent.
	if [ "$( ssh-add -L 2> /dev/null | grep "${signing_pubkey}" )" ];
	then
		echo '\e[1;33mi\e[0m Signing key is already present in SSH agent'
		return
	fi

	# Check if tmux contains environment variable for forwarded SSH agent.
	if tmux_env="$(tmux showenv -s SSH_AUTH_SOCK)"; then
		eval "${tmux_env}"
		if [ "$( ssh-add -L 2>&- | grep "${signing_pubkey}" )" ];
		then
			echo "\e[1;33mi\e[0m Activated SSH agent from tmux environment"
			return
		fi
	fi

	# Bitwarden takes a second to prompt for master password.
	# Prompting like this allows to user to immediately start typing their password after invocation.
	echo -n '\e[0;32m?\e[0;0m Master password: \e[1;30m[input is hidden] \e[0;0m'
	read -s PASSWORD
	echo
	if [ -z $PASSWORD ]
	then
		echo '\e[0;31m!\e[0m Master password must not be empty'
		echo '  \e[0;37mMake sure to type your master password when prompted.'
		return 1
	fi

	echo '  \e[1;30m[unlocking]\e[0;0m'
	# TODO Print detailed error instructions based on stderr output.
	if BW_SESSION="$(bw unlock "${PASSWORD}" --raw 2> /dev/null)"
	then
	else
		echo '\e[0;31m!\e[0m Failed to unlock Bitwarden vault'
		echo '  \e[0;37mMake sure you are logged in by running `bw login`, and the master password is correct.'
		return 1
	fi

	# Start new SSH agent, fetch private key from vault, and add private key to SSH agent.
	if eval "$(ssh-agent -s)" > /dev/null && BW_SESSION="${BW_SESSION}" bw get notes "${BITWARDEN_SSH_KEY_NOTE_ID}" 2> /dev/null | ssh-add - 2> /dev/null;
	then
		echo '  \e[1;30m[key added]\e[0;0m'
	else
		echo '\e[0;31m!\e[0m Failed to get secret note or during ssh-add'
		echo '  \e[0;37mTry to manually add the key by running:'
		echo '  \e[0;37meval "$(ssh-agent)"' "&& bw get notes \"${BITWARDEN_SSH_KEY_NOTE_ID}\" | ssh-add -"
		return 1
	fi

	# Lock vault to invalidate BW_SESSION.
	if bw lock > /dev/null
	then
		echo '\e[1;33mi\e[1;30m [vault is locked]\e[0;0m'
	else
		echo '\e[0;31m!\e[0m Failed to lock Bitwarden vault'
		echo '  \e[0;37mLock your vault with `bw lock` to keep it safe.'
	fi
}
