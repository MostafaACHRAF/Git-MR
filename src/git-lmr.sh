#!/bin/bash

#@Author : Mostafa ASHARF
#@email : mostafaegma@wgmail.com
#@Date : 04/02/2019
#@Last update : 27/12/2020
#@Version : 4.3.0
#Developed will listening to piano music \(^_^)/

data="${1}"

projectId=$(gpm -getj projectId "${data}")
accessToken=$(gpm -getj accessToken "${data}")
username=`gpm -getj username "${data}"`
repo=`gpm -getj repo "${data}"`
owner=`gpm -getj owner "${data}"`
sourceBranch=`gpm -getj sourceBranch "${data}"`
targetBranch=`gpm -getj targetBranch "${data}"`
title=`gpm -getj mrTitle "${data}"`
labels=`gpm -getj labels "${data}"`
assignee=`gpm -getj assigneeUser "${data}"`
domainName=`gpm -getj domainName "${data}"`
projectsUrl=https://${domainName}/api/v4/projects
usersUrl=https://${domainName}/api/v4/users

#==============================================================================================================================

assigneeId=`curl --header "Private-Token:${accessToken}" --silent "${usersUrl}?username=${assignee}" | jq '.[0].id'`
authorId=`curl --header "Private-Token:${accessToken}" --silent "${usersUrl}?username=${username}" | jq '.[0].id'`

if [[ -z "${authorId}" || -z "${assigneeId}" ]]; then
  log "error" "Error! authorId and assigneeId can't be null."
  log "info" "👉 Check your configuration in: ${gitProjects}"
  exit 1
fi

body="{
  \"id\": ${projectId},
  \"source_branch\": \"${sourceBranch}\",
  \"target_branch\": \"${targetBranch}\",
  \"remove_source_branch\": true,
  \"title\": \"${title}\",
  \"assignee_id\": ${assigneeId},
  \"author_id\":${authorId},
  \"labels\": \"${labels}\"
}"

echo "${body}"

read -p "> Create a merge request for [${sourceBranch}] into [${targetBranch}] [y/n]?" proceed
  
case "${proceed}" in
  [yY]*)
    curl -X POST "${projectsUrl}/${projectId}/merge_requests" \
        --header "PRIVATE-TOKEN:${accessToken}" \
        --header "Content-Type: application/json" \
        --data "${body}"

    mergeRequestUrl="${projectsUrl}/${projectId}/merge_requests?state=opened&order_by=created_at&assignee_id=${assigneeId}&author_id=${authorId}"
    mergeRequestIID=`curl --header "Private-Token:${accessToken}" --silent "${mergeRequestUrl}" | jq '.[0].iid'`

    if [[ -z "${mergeRequestIID}" && "${mergeRequestIID}" != null ]]; then
        log "error" "Error! something went wrong. Merge request failed."
        exit 1
    fi
    createdMergeRequestUrl="https://${domainName}/${owner}/${repo}/merge_requests/${mergeRequestIID}"
    printf "\n"
    log "success" "🎉🎉🎉 Success! merge request [${mergeRequestIID}] has been created successfully."
    if [[ ! -z "${isDockerContainer}" ]]; then log "warning" "visit: ${createdMergeRequestUrl}"; else chromium ${createdMergeRequestUrl}; fi
    exit 0
    ;;
  *)
    log "warning" "Merge request canceled."
    exit 1 
    ;; 
esac