#!/bin/bash

data="${1}"

accessToken=$(gpm -getj accessToken "${data}")
username=`gpm -getj username "${data}"`
repo=`gpm -getj repo "${data}"`
owner=`gpm -getj owner "${data}"`
sourceBranch=`gpm -getj sourceBranch "${data}"`
targetBranch=`gpm -getj targetBranch "${data}"`
headBranch="${username}:${sourceBranch}"
baseBranch="${targetBranch}"
title=`gpm -getj mrTitle "${data}"`
isDraft=`gpm -getj draft "${data}"`
labels=`gpm -getj labels "${data}"`
assignees=`gpm -getj assigneeUsers "${data}"`

if [[ -z "${username}" || -z "${owner}" || -z "${repo}" || -z "${headBranch}" || -z "${baseBranch}" ]]; then
    errorDetails="{headBranch=${headBranch}, baseBranch=${baseBranch}, owner=${owner},repo=${repo}, username=${username}}"
    log "error" "Error! {headBranch, baseBranch, owner, repo} are required!"
    log "info" "👉 check your configuration file in : ${gitProjects}"
    exit 1
fi

# format labels and assignees fields, to be accepted json arrays
labels="\"${labels//,/\",\"}\""
assignees="\"${assignees//,/\",\"}\""

body="{
    \"head\":\"${headBranch}\",
    \"base\":\"${baseBranch}\",
    \"title\":\"${title}\",
    \"draft\":${isDraft},
    \"labels\":[${labels}],
    \"assignees\":[${assignees}]
}"

printf "${body}\n"
read -p "?Create pull request of [${headBranch}] by [${baseBranch}]? y/n: " response

case "${response}" in
    y|Y)
        pullsUrl="https://api.github.com/repos/${owner}/${repo}/pulls"
        issuesUrl="https://api.github.com/repos/${owner}/${repo}/issues"

        printf "\n==> Create new pull request [${pullsUrl}]..."
        errors=`curl -s -o \
            -X POST \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token ${accessToken}" \
            ${pullsUrl} \
            -d "${body}" | jq .errors[0].message`


        if [[ "${errors}" != "null" ]]; then
            log "error" "Error! failed to create pull request."
            log "info" "👉 ${errors}"
            exit 1
        fi

        sleep 3s

        printf "Done.\n==> Get pull request id..."
        pullId=`curl -s -o -H "Accept: application/vnd.github.v3+json" "${pullsUrl}?status=open&head=${headBranch}" | jq .[0].number`
        pullUrl="https://github.com/${owner}/${repo}/pull/${pullId}"

        if [[ "${pullId}" == "null" ]]; then
            log "error" "Error! failed to get pull request: [${pullId}]! After waiting for 3 seconds."
            exit 1
        fi

        printf "Done.\n==> Set labels and assignees..."
        errors=`curl -s -o \
            -X PATCH \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token ${accessToken}" \
            ${issuesUrl}/${pullId} \
            -d "${body}" | jq .errors[0].message`

        if [[ "${errors}" != "null" ]]; then
            log "error" "Error! failed to set (labels) and (assignees) fields into pull request: [${pullId}]."
            log "info" "👉 ${errors}"
            exit 1
        fi

        printf "Done."
        log "success" "🎉🎉🎉 Success! pull request [${pullId}] has been created successfully."
        if [[ ! -z "${isDockerContainer}" ]]; then log "warning" "visit: ${pullUrl}"; else chromium ${pullUrl}; fi
        exit 0
        ;; 
    *)
        log "warning" "Pull request canceled."
        exit 1 
        ;; 
esac
    