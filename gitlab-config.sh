#!/bin/bash
   
echo "Configure Gitlab integration..."
read -p "> [Gitlab url]: " GITLAB_URL
read -p "> [Gitlab project name]: " GITLAB_PROJECT_NAME
read -p "> [Private token]: " PRIVATE_TOKEN

configFile="./gitlab.conf"

if [[ -n "${GITLAB_URL}" && -n "${GITLAB_PROJECT_NAME}" && -n "${PRIVATE_TOKEN}" ]]; then
  GITLAB_URL="${GITLAB_URL//(.+)\//ddddd}"
  GITLAB_URL="${GITLAB_URL//\//\\/}"
  echo "modified url = ${GITLAB_URL}"
  echo "==> SET Gitlab url..."
  sed -i -E 's/'"^(GITLAB_URL=).*"'/\1'"${GITLAB_URL}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; echo "Done!"; fi

  echo "==> SET Gitlab project name..."
  sed -i -E 's/'"^(GITLAB_PROJECT_NAME=).*"'/\1'"${GITLAB_PROJECT_NAME}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; echo "Done!"; fi

  echo "==> SET Gitlab private token..."
  sed -i -E 's/'"^(PRIVATE_TOKEN=).*"'/\1'"${PRIVATE_TOKEN}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; echo "Done!"; fi
    
  echo "All done! GitMR is ready 🔥🔥🔥"
  echo "You need help? Type git mr --help or visit our repository: https://github.com/MostafaACHRAF/Git-MR"
  exit 0
fi

echo "Gitlab configuration has failed! Because of INVALID params."
