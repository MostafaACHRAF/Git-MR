#!/bin/bash
   
echo "Configure Gitlab integration..."
printf "\n"
read -p "> [Gitlab url]: " GITLAB_URL
read -p "> [Gitlab project name]: " GITLAB_PROJECT_NAME
read -p "> [Gitlab project id]: " GITLAB_PROJECT_ID
read -p "> [Private token]: " PRIVATE_TOKEN
printf "\n"

# ${1} : config file path
configFile="${1}"


if [[ ! -f "${configFile}" ]]; then
  echo "==> Generate new config file [${configFile}]..."
  echo "#========================= Gitlab integration configuration =========================" >> "${configFile}"
  echo "GITLAB_PROJECT_NAME=" >> "${configFile}"
  echo "GITLAB_PROJECT_ID=" >> "${configFile}"
  echo "GITLAB_URL=" >> "${configFile}"
  echo "PRIVATE_TOKEN=" >> "${configFile}"
  echo "GITLAB_PROJECTS_URL=\"${GITLAB_URL}/api/v4/projects\"" >> "${configFile}"
  echo "GITLAB_USERS_URL=\"${GITLAB_URL}/api/v4/users\"" >> "${configFile}"
  echo "GITLAB_MRS_URL=\"${GITLAB_URL}/${GITLAB_PROJECT_NAME}/merge_requests\"" >> "${configFile}"
  echo "#======= DO NOT THIS LINE. THIS LINE SHOULD BE THE LAST ONE !!!!" >> "${configFile}"
  if [[ $? == 1 ]]; then echo "🚨 Erro! Something went wrong will generating config file! 🚨"; exit 1; else echo "Done ✔"; fi
fi


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
  sed -i -E 's/'"^(GITLAB_PROJECT_NAME=).*"'/\1'"${GITLAB_PROJECT_NAME//\//\\/}"'/g' "${configFile}"
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

echo "🚨 Gitlab configuration has failed! Because of INVALID params. 🚨"
echo "All params are required.🧐"
exit 1
