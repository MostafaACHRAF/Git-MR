#!/bin/bash
   
echo "Configure Gitlab integration..."
printf "\n"
read -p "> [Gitlab url]: " GITLAB_URL
read -p "> [Gitlab project name]: " GITLAB_PROJECT_NAME
read -p "> [Gitlab project id]: " GITLAB_PROJECT_ID
read -p "> [Private token]: " PRIVATE_TOKEN
printf "\n"

configFile="./gitlab.conf"

if [[ -n "${GITLAB_URL}" && -n "${GITLAB_PROJECT_NAME}" && -n "${PRIVATE_TOKEN}" ]]; then 
  echo "==> Prepared Gitlab url..."
  if [[ "${GITLAB_URL}" =~ ^https?:\/\/.+ ]]; then 
    echo "Done ✔"; 
      else echo "🚨 Error! Gitlab url must start with [https:// | http://] 🚨"; 
      exit 1; 
  fi
  GITLAB_URL="${GITLAB_URL%*/}" # Remove the last "/" from the url
  GITLAB_URL="${GITLAB_URL//\//\\/}" # Replace all "/" with "\/"
  
  echo "==> SET Gitlab url..."
  sed -i -E 's/'"^(GITLAB_URL=).*"'/\1'"${GITLAB_URL}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; else echo "Done ✔" ; fi

  echo "==> SET Gitlab project name..."
  sed -i -E 's/'"^(GITLAB_PROJECT_NAME=).*"'/\1'"${GITLAB_PROJECT_NAME}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; else echo "Done ✔️"; fi

  echo "==> SET Gitlab project id..."
  sed -i -E 's/'"^(GITLAB_PROJECT_ID=).*"'/\1'"${GITLAB_PROJECT_ID}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; else echo "Done ✔️"; fi

  echo "==> SET Gitlab private token..."
  sed -i -E 's/'"^(PRIVATE_TOKEN=).*"'/\1'"${PRIVATE_TOKEN}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then exit 1; else echo "Done ✔️"; fi
    
  printf "\n"
  echo "All done! GitMR is ready 🔥🔥🔥"
  echo "👉 You need help? Type git mr --help" 
  echo "👉 Or visit our repository: https://github.com/MostafaACHRAF/Git-MR"
  exit 0
fi

echo "Gitlab configuration has failed! Because of INVALID params.🚨"
echo "All params are required.🧐"
exit 1