#!/bin/bash

WIDTH=30
HEIGHT=30
CHOICE_HEIGHT=4
TITLE="GitMR configuration..."
MENU="Choose the VCS to configure:"
OPTIONS=("Gitlab" "Github")
TERMINAL=$(tty)

option=$(zenity --title="${TITLE}" --text="${MENU}" --list --column="Options" "${OPTIONS[@]}"); 


if [[ -n "${option}" ]]; then
    echo "option = $option"
    case "${option}" in
        Gitlab)
        ./gitlab-config.sh
        ;;
        Github)
        echo "congigure github..."
        ;;
    esac
fi  