#!/bin/bash

# Colors for Messages
GREEN=`tput setaf 2`
RED=`tput setaf 1`
MAGENTA=`tput setaf 5`
RST=`tput sgr0`

# Print some info to stdout
function info {
	echo "[i] $@"
}

function ok {
	echo "[${GREEN}✓${RST}] $@"
}

function error {
	echo "[${RED}✗${RST}] $@"
}

function info_work {
	echo "[${GREEN}i${RST}] [${MAGENTA}workmode${RST}] $@"
}

function usage {
	echo ""
	echo """This script will make symlinks to your dotfiles. If you add the -work (-w) flag it will use the files marked with .work.

Arguments:
--work (-w) for work configuration
--help (-h) this information

"""
}

# Init some things
function init {
	if ! which git >/dev/null; then
		info "We need ${RED}git${RST}! Installing..."
		sudo apt -y install git
	fi

	info "Update/Pull from GIT"
	if [ -d $HOME/.dotfiles ]; then
		ok "Dotfile repo found. Updateing..."
		cd $HOME/.dotfiles
		git pull
	else
		error "Dotfile repo not found."
		info "Cloning it into ${RED}$HOME/.dotfiles${RST}"
		if [ -z "$GT" ]; then
			info "No GitHub token found."
			read -s -p "${MAGENTA}[Access Token]${RST} Please enter your github access token: " token </dev/tty
			git clone https://$token@github.com/Brazier85/dotfiles.git $HOME/.dotfiles
		else
			info "GitHub token found."
			git clone https://$GT@github.com/Brazier85/dotfiles.git $HOME/.dotfiles
		fi
	fi
	ok "Update complete"
	cd $HOME/.dotfiles

	info "Installing pip"
	sudo apt install -y python3-pip

	info "Installing Ansible"
	sudo python3 -m pip install ansible
}

# Need help?!
if ([ "$1" == "--help" ] || [ "$1" == "-h" ]) then
	usage
	exit 0
fi

# Run init function
init
# Run stuff for all workstations

# Override some files with work stuff?
info "Starting Ansible Playbook"
if ([ "$1" == "--work" ] || [ "$1" == "-w" ]) then
	info_work "Starting Ansible in WORK mode"
	ansible-playbook -i $HOME/.dotfiles/hosts $HOME/.dotfiles/playbook.yml --ask-become-pass --extra-vars "work=True"
else
	ansible-playbook -i $HOME/.dotfiles/hosts $HOME/.dotfiles/playbook.yml --ask-become-pass
fi

# Check if repo is in ssh mode
REPO_URL=`git remote -v | grep -m1 '^origin' | sed -Ene's#.*(git@github.com[^[:space:]]*).*#\1#p'`
if [ -z "$REPO_URL" ]; then
	error "Git repo not set to ssh"
	read -n 1 -p "${MAGENTA}[Question]${RST} Change dotfile git remote url to ssh (y/n)? " answer
	echo ""

	if [ "$answer" != "${answer#[Yy]}" ] ;then
		ok "Changing repo to ssh"
		git remote set-url origin git@github.com:Brazier85/dotfiles_public.git
	fi
else
	ok "Git remote url is set to ssh"
fi

info "done"
