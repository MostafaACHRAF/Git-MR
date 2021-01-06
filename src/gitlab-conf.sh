#!/bin/bash

projectAlias="${1}"

if [ -z "${projectAlias}" ]; then
  read -p "> Gitlab project alias: " projectAlias
  else
    echo "> Gitlab project alias: ${projectAlias}"
fi
read -p "> Gitlab username: " username
read -p "> Gitlab project id: " projectId
read -p "> Gitlab access token: " accessToken
read -p "> Organization domain name: " domainName
read -p "> Gitlab Full repository name: " repo

if [[ -z "${projectAlias}" ]]; then
  log "error" "Error! invalid project alias."
  exit 1
fi

if [[ -z "${domainName}" ]]; then
  domainName="gitlab.com"
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
  \"alias\":\"${projectAlias}\",
  \"username\":\"${username}\",
  \"token\":\"${accessToken}\",
  \"projectId\":\"${projectId}\",
  \"domainName\":\"${domainName}\",
  \"owner\":\"${owner}\",
  \"repo\":\"${repo}\",
  \"vcs\":\"gitlab\"
}"

read -p "?Create gitlab project alias? y/n: " response

case "${response}" in
    y|Y)
      gpm -na "${data}"
      ;;
    *)
      log "warning" "Creating new gitlab project alias has been canceled!"
      ;;
esac
