#!/bin/bash
   
printf "Configure Gitlab integration...\n"
printf "\n"
read -p "> [Gitlab url]: " GITLAB_URL
read -p "> [Private token]: " PRIVATE_TOKEN
USER_EMAIL=$(git config user.email)
if [[ -z "${USER_EMAIL}" ]]; then
  read -p "> [Gitlab user.email]: " USER_EMAIL
fi

printf "\n"

# ${1} : config file path
configFile="${configDir}/gitlab.conf"

if [[ ! -f "${configFile}" ]]; then
  printf "==> Generate new config file [${configFile}]..."
  printf "GITLAB_URL=\n" >> "${configFile}"
  printf "PRIVATE_TOKEN=\n" >> "${configFile}"
  printf "GITLAB_PROJECTS_URL=${GITLAB_URL}/api/v4/projects\n" >> "${configFile}"
  printf "GITLAB_USERS_URL=${GITLAB_URL}/api/v4/users\n" >> "${configFile}"
  printf "GITLAB_MRS_URL=${GITLAB_URL}/${GITLAB_PROJECT_NAME}/merge_requests\n" >> "${configFile}"
  printf "USER_EMAIL=${USER_EMAIL}" >> "${configFile}"
  printf "\n" >> "${configFile}"
  if [[ $? == 1 ]]; then printf "\n🚨 Erro! Something went wrong will generating config file! 🚨\n"; exit 1; else printf "Done ✔\n"; fi
fi

if [[ -n "${GITLAB_URL}" && -n "${PRIVATE_TOKEN}" ]]; then 
  printf "==> Prepared Gitlab url..."
  if [[ "${GITLAB_URL}" =~ ^https?:\/\/.+ ]]; then 
    printf "Done ✔\n"; 
      else printf "" > "${configFile}"; printf "\n🚨 Error! Gitlab url must start with [https:// | http://] 🚨\n"; 
      exit 1; 
  fi
  GITLAB_URL="${GITLAB_URL%*/}" # Remove the last "/" from the url
  GITLAB_URL="${GITLAB_URL//\//\\/}" # Replace all "/" with "\/"
  
  printf "==> SET Gitlab url..."
  sed -i -E 's/'"^(GITLAB_URL=).*"'/\1'"${GITLAB_URL}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then printf "\n"; exit 1; else printf "Done ✔\n" ; fi

  printf "==> SET Gitlab private token..."
  sed -i -E 's/'"^(PRIVATE_TOKEN=).*"'/\1'"${PRIVATE_TOKEN}"'/g' "${configFile}"
  if [[ $? == 1 ]]; then printf "\n"; exit 1; else printf "Done ✔️\n"; fi

  printf "\nAll done! GitMR is ready 🔥🔥🔥\n"
  printf "👉 You need help? Type git mr --help\n" 
  printf "👉 Or visit our repository: https://github.com/MostafaACHRAF/Git-MR\n"
  exit 0
fi

printf "\n🚨 Gitlab configuration has failed! Because of INVALID params. 🚨"
printf "👉 All params are required.🧐\n"
exit 1