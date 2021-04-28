# dotfiles
My personal dotfiles

## Usage

Use curl or the github webpage to download the `bootstap.sh` file and execute it. 

Set github access token as environment var
```
export GT=TOKEN
```
```
Home:
curl -H "Authorization: token $GT" https://raw.githubusercontent.com/Brazier85/dotfiles_public/master/bootstrap.sh | bash

Work:
curl -H "Authorization: token $GT" https://raw.githubusercontent.com/Brazier85/dotfiles_public/master/bootstrap.sh | bash -s -- -w
```

## Ansible

The whole dotfile repo is based on ansible. Take a look at the tasks dir!

## Folders

### config

In this folder you can place any dotfile you want on your machines. You have to add new files into the `playbook.yml` or create a task for them. Files with `.work` as ending will be uses for Work files.

### tasks

Here you can find all the tasks used by ansible
