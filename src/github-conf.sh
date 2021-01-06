#!/bin/bash

read -p "> Github project alias: " projectAlias
read -p "> Github username: " username
read -p "> Github access token: " accessToken
read -p "> Github full repository name:" repo

if [[ -z "${projectAlias}" ]]; then
    log "error" "Error! invalid project alias."
    exit 1
fi

isAliasExist=`gpm -ae ${projectAlias}`

owner=${repo%%/*}
repo=${repo##*/}

if [[ -z "${isAliasExist}" && -z "${owner}" ]]; then 
    log "error" "Error! invalid github owner.";
    log "info" "👉 Please enter the full repo name: {owner}/{repo} like :"
    log "info" "👉 MostafaACHRAF/Git-MR"
    exit 1
fi

data="{
    \"alias\": \"${projectAlias}\",
    \"username\": \"${username}\",
    \"token\": \"${accessToken}\",
    \"repo\": \"${repo}\",
    \"owner\": \"${owner}\",
    \"vcs\": \"github\"
}"

read -p "?Create github project alias? y/n: " response

case "${response}" in
    y|Y)
        gpm -na "${data}"
        ;;
    *)
        log "warning" "Creating new github project alias has been canceled!"
        ;;
esac
