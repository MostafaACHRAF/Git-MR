#!/bin/bash


#@Author : Mostafa ASHARF
#@email : mostafaegma@wgmail.com
#@Date : 04/02/2019
#@Last update : 20/03/2020
#@Version : 3.0
#Developed will listening to piano music \(^_^)/


#git lmr <target_branch[optional;default=dev]>
#assigned_to : <assigned_to[optional;default=me]>
#labels : <commit_label(list)[optional;default=java;separator=,]>
#git lmr -i : interactive mode, this helps you fill the params in an interactive way, (question => response)

#======= FUN CONFIG =======
#example : "GITLAB-PROJECT-NAME/GITLAB-PROJECT-NAME"

#example : "https://gitlab.orewa.sasa.com"

params=()
echo "Load gitlab configuration..."
while read line; do
  if [[ "${line}" =~ ^([^\#=\s]+)\s*=(.*) ]]; then
    params+=("${BASH_REMATCH[1]}=${BASH_REMATCH[2]}")
  fi
done < ./gitlab.conf

getConf() {
  # $1 : key
  for param in "${params[@]}"; do
    key=${param%%=*}
    value=${param##*=}
    if [[ "${1}" == "${key}" ]]; then
      echo "${value}"
      break;
    fi
  done
}

GITLAB_PROJECT_NAME=$(getConf "GITLAB_PROJECT_NAME")
GITLAB_PROJECT_ID=$(getConf "GITLAB_PROJECT_ID")
GITLAB_URL=$(getConf "GITLAB_URL")
PRIVATE_TOKEN=$(getConf "PRIVATE_TOKEN")
GITLAB_PROJECTS_URL=$(getConf "GITLAB_PROJECTS_URL")
GITLAB_USERS_URL=$(getConf "GITLAB_USERS_URL")
GITLAB_MRS_URL=$(getConf "GITLAB_MRS_URL")

echo "gitlab project name :  ${GITLAB_PROJECT_NAME}"
echo "gitlab project id :  ${GITLAB_PROJECT_ID}"
echo "gitlab url :  ${GITLAB_URL}"
echo "private token : ${PRIVATE_TOKEN}"
echo "gitlab projects url: ${GITLAB_PROJECTS_URL}"
echo "gitlab users url: ${GITLAB_USERS_URL}"
echo "gitlab mrs url: ${GITLAB_MRS_URL}"

#======= PREPARE FUN PARAMS =======

SOURCE_BRANCH="${1}"
TARGET_BRANCH="${2}"
ASSIGNEE_USER="${3}"
MR_TITLE="${4}"
LABELS="${5}"

DEFAULT_SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DEFAULT_MR_TITLE=$(git log --pretty=format:%s HEAD | head -n 1)
ACTUAL_USER_EMAIL=$(git config user.email)
ACTUAL_USER_USERNAME=${ACTUAL_USER_EMAIL%%@*}
DEFAULT_TARGET_BRANCH="release/tefal_rtdtc_temp"
OS="LINUX"

if [[ -z "${SOURCE_BRANCH}" ]]; then
  SOURCE_BRANCH="${DEFAULT_SOURCE_BRANCH}"
fi

if [[ -z "${TARGET_BRANCH}" ]]; then
  TARGET_BRANCH="${DEFAULT_TARGET_BRANCH}"
fi

if [[ -z "${ASSIGNEE_USER}" ]]; then
  ASSIGNEE_USER=${ACTUAL_USER_USERNAME}
fi

if [[ -z "${MR_TITLE}" ]]; then
  MR_TITLE="${DEFAULT_MR_TITLE}"
  elif [[ "$MR_TITLE" =~ wip:|WIP: ]]; then
    MR_TITLE="${MR_TITLE}${DEFAULT_MR_TITLE}"
fi


#======= Main fun =======
echo ">> [Core] : Gitlab auto merge request v.3.0"
echo ">> [Project] : ${GITLAB_PROJECT_NAME}"
printf "\n"

#TARGET_GITLAB_PROJECT_ID=`curl --header "Private-Token:${PRIVATE_TOKEN}" --silent "${GITLAB_PROJECTS_URL}" | jq '.[] | select(.path_with_namespace=="'${GITLAB_PROJECT_NAME}'") | .id'`
TARGET_GITLAB_PROJECT_ID=118
ASSIGNEE_GITLAB_USER_ID=`curl --header "Private-Token:${PRIVATE_TOKEN}" --silent "${GITLAB_USERS_URL}?username=${ASSIGNEE_USER}" | jq '.[0].id'`
AUTHOR_ID=`curl --header "Private-Token:${PRIVATE_TOKEN}" --silent "${GITLAB_USERS_URL}?username=${ACTUAL_USER_USERNAME}" | jq '.[0].id'`

if [[ "${AUTHOR_ID}" != null && "${ASSIGNEE_GITLAB_USER_ID}" ]]; then
  BODY="{
    \"id\": ${TARGET_GITLAB_PROJECT_ID},
    \"source_branch\": \"${SOURCE_BRANCH}\",
    \"target_branch\": \"${TARGET_BRANCH}\",
    \"remove_source_branch\": true,
    \"title\": \"${MR_TITLE}\",
    \"assignee_id\": ${ASSIGNEE_GITLAB_USER_ID},
    \"author_id\":${AUTHOR_ID},
    \"labels\": \"${LABELS}\"
  }"

  echo "${BODY}"

  read -p ">> [?] : Do you want to create a merge request for [${SOURCE_BRANCH}] into [${TARGET_BRANCH}] [y/n]?" PROCEED
  
  case "${PROCEED}" in
    [yY]* )
    curl -X POST "${GITLAB_PROJECTS_URL}/${TARGET_GITLAB_PROJECT_ID}/merge_requests" \
         --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}" \
         --header "Content-Type: application/json" \
         --data "${BODY}";

    CREATED_MR_URL="${GITLAB_PROJECTS_URL}${TARGET_GITLAB_PROJECT_ID}/merge_requests?state=opened&order_by=created_at&assignee_id=${ASSIGNEE_GITLAB_USER_ID}&author_id=${AUTHOR_ID}"
    CREATED_MR_IID=`curl --header "Private-Token:${PRIVATE_TOKEN}" --silent "${CREATED_MR_URL}" | jq '.[0].iid'`
    echo "CREATED_MR_IID = ${CREATED_MR_IID}"
    if [[ "${CREATED_MR_IID}" != null ]]; then
      if [[ "${OS}" == "LINUX" ]]; then
        xdg-open "${GITLAB_MRS_URL}${CREATED_MR_IID}"
      elif [[ "${OS}" == "WINDOWS" ]]; then
        start "${GITLAB_MRS_URL}${CREATED_MR_IID}"
      fi
    else
      printf "\n>> [Error] : Something went wrong, this merge request can't be created !\n"
    fi
    ;;
  esac

else
  if [[ "${ASSIGNEE_GITLAB_USER_ID}" == null ]]; then
    echo ">> [Invalid] : User.name, [ASSIGNEE_GITLAB_USER_ID=${ASSIGNEE_GITLAB_USERNAME}] !"
  else
    echo ">> [Invalid] : User.name, [ACTUAL_USER_USERNAME=${ACTUAL_USER_USERNAME}] !"
  fi
fi