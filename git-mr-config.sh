#!/bin/bash

# TODO : create menu list using nodeJs <3
WIDTH=30
HEIGHT=30
CHOICE_HEIGHT=4
TITLE="GitMR configuration..."
MENU="Choose the VCS to configure:"
OPTIONS=("Gitlab" "Github")
TERMINAL=$(tty)

option=$(zenity --title="${TITLE}" --text="${MENU}" --list --column="Options" "${OPTIONS[@]}"); 

configDir="${1}"

if [[ -n "${option}" ]]; then
    echo "option = $option"
    case "${option}" in
        Gitlab)
        /bin/GitMR/gitlab-config.sh "${configDir}/gitlab.conf"
        ;;
        Github)
        echo "configure github..."
        echo "call  /bin/GitMR/github-config.sh \"${configDir}/github.conf\""
        ;;
    esac
fi  