#!/bin/bash

read -p "> Github project alias: " projectAlias
read -p "> Github username: " username
read -p "> Github access token: " accessToken
read -p "> Github full repository name:" repo

owner=${repo%%/*}
repo=${repo##*/}

if [[ -z "${owner}" ]]; then printf "\nError! invalid owner.\n Please enter the full repo name: {owner}/{repo}\n"; exit 1; fi

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
    sh ${srcDir}/gpm.sh -na "${data}"
    ;;
    *)
    printf "\nCreating new github project alias canceled!\n"
    ;;
esac
