#!/bin/bash
  
read -p "> Gitlab project alias: " projectAlias
read -p "> Gitlab username: " username
read -p "> Gitlab project id: " projectId
read -p "> Gitlab access token: " accessToken
read -p "> Organization domain name: " domainName

if [[ -z "${projectAlias}" ]]; then
  log "error" "Error! invalid project alias."
  exit 1
fi

if [[ -z "${domainName}" ]]; then
  domainName="gitlab.com"
fi

data="{
  \"alias\":\"${projectAlias}\",
  \"username\":\"${username}\",
  \"token\":\"${accessToken}\",
  \"projectId\":\"${projectId}\",
  \"domainName\":\"${domainName}\",
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
