#!/bin/bash

node ${utilsDir}/vcs_menu/menu.js
vcs=$(cat ${configDir}/menu.log)

case "${vcs}" in
    Gitlab)
    sh ${srcDir}/gitlab-config.sh "${configDir}/gitlab.conf"
    ;;
    Github)
    echo "Github config"
    ;;
esac