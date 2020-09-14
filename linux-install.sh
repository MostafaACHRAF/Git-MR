#!/bin/bash

#@Author : Mostafa ASHARF
#@Date (en) : 05/04/19
#@Last update (en) : 06/09/19
#@Version : 3.0
#Developed will listening to piano music \(^_^)/

VERSION=4.0
echo "#########################################"
echo "###/  __\##(_)#|_   _|##| \##/ |#|  _ \##"
echo "##| |############| |####|  \/  |#| |#||##"
echo "##| |#\ _\#| |###| |####| |\/| |#|  _ \##"
echo "##\_____|##|_|###|_|#()#|_|##|_|#|_|#|_\#"
echo "#########################################"
printf "V.${VERSION}\n\n"
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CONFIG @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#clone the repository to /bin
#give the scripts execution rights
#then run the installer script
#done!
# git clone https://github.com/MostafaACHRAF/Git-MR /bin && chmod +x /bin/Git-MR*.sh && .linux-install.sh



SRC_PATH="/bin/GitMR"
# SRC_SCRIPT="git-lmr"
# SRC_SCRIPT_PATH="${SRC_PATH}/${SRC_SCRIPT}"
PKG_MANAGER="NONO"
ZSH_CONF_PATH=~/.zshrc
BASH_CONF_PATH=~/.bashrc
ZSH_BASH_VAR_PATH="PATH=\$PATH:${SRC_PATH}"
ZSH_BASH_VAR_PATH_REGEX="PATH=\\\$PATH:${SRC_PATH//'/'/'\/'}"

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ UTILS FUNCTIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SUCCESS_RATE=0
TOTAL_STEPS=2
logByStepAndState() {
  #${1} : STEP ; ${2} : STATE
  remainingSteps=()
  case ${1} in
    "1" )
    if [[ "${2}" == true ]];then
      echo "Done ✔"
      ((SUCCESS_RATE++))
      else
        echo "🚨 Error! Unsupported script shell. We support only ZSH and BASH shell scripts 🚨"
        echo "👉 Add [${SRC_PATH}] to your varialbe PATH manually."
        remainingSteps+=("Add [${SRC_PATH}] to your variable PATH.")
    fi
    ;;
    "2" )
    if [[ "${2}" == true  ]];then
      echo "Done ✔"
      ((SUCCESS_RATE++))
      else
        echo "🚨 Error! Looks like your package manager is not supported. 🚨"
        echo "👉 You can install [jq] manually: https://stedolan.github.io/jq/download/"
        remainingSteps+=("Install [jq] manually: https://stedolan.github.io/jq/download/")
    fi
    ;;
  esac
  printf "\n"
  echo "==> SUCCESS STEPS = [${SUCCESS_RATE}/${TOTAL_STEPS}]"
}

appendStringToFile() {
  #${1} : STRING, ${2} : FILE_PATH
  if [[ -f "${2}" ]]; then
    if ! grep "${1}" "${2}"; then
      echo "${1}" >> "${2}"
      IS_STEP1_SUCCEEDED=true
    fi
  fi
}

# removeVariablePathFrom() {
#   #${1} : FILE_PATH
#   echo ">> [Delete] : The variable path from : [${1}]..."
#   sed -i 's/'"^${ZSH_BASH_VAR_PATH_REGEX}"'//g' "${1}"
# }

# configureOS4SrcScript() {
#   echo "==> Add detected OS (Linux) to [${SRC_SCRIPT}]..."
#   sudo sed -i -E 's/^(OS=).*/\1"LINUX"/g' "${SRC_SCRIPT_PATH}"
# }

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ MAIN FUN @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IS_STEP1_SUCCEEDED=false
IS_STEP2_SUCCEEDED=false

echo "Git-MR installation..."

#Copy ${SRC_SCRIPT} to ${SRC_PATH}
# if [[ -d "${SRC_PATH}" ]]; then
  # echo "⚠️ GitMR is already installed ! ⚠️" 
  # echo "👉 If you want to uppdate it run: git mr --update"
  # echo "👉 If you want to uninstall it run: git mr --remove"
  # exit 1
  # echo "RESPONSE = ${RESPONSE}"
  # if [[ "${RESPONSE}" == "y" || "${RESPONSE}" == "Y" ]]; then
  #   sudo rm -rf "${SRC_PATH}"
  #   removeVariablePathFrom "${ZSH_CONF_PATH}"
  #   removeVariablePathFrom "${BASH_CONF_PATH}"
  #   echo ">> [Result] : Auto.Git.Mr has been removed successfully..."
  # fi
# fi

# if [[ ! -d "${SRC_PATH}" ]];then
#   sudo mkdir "${SRC_PATH}"
#   sudo cp "${SRC_SCRIPT}" "${SRC_PATH}"
#   if [[ -f "${SRC_SCRIPT_PATH}" ]]; then
#     configureOS4SrcScript
#     IS_STEP1_SUCCEEDED=true
#   fi
#   logByStepAndState "1" "${IS_STEP1_SUCCEEDED}"
# fi

# if [[ -d "${GITMR_DIR}" ]]; then
#     configureOS4SrcScript
#     if [[ $? == 0 ]]; then IS_STEP1_SUCCEEDED=true; fi
#     logByStepAndState "1" "${IS_STEP1_SUCCEEDED}"
# fi

#Add ${SRC_PATH} to path [~/.zshrc, and ~/.bashrc]
#ToDo...for Other SHELLs [$KSH_VERSION,$FCEDIT,$PS3]
echo "==> Update PATH variable..."
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${ZSH_CONF_PATH}"
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${BASH_CONF_PATH}"
logByStepAndState "1" "${IS_STEP1_SUCCEEDED}"

#Download and install jq on [debian-base, and other distros...]
IS_STEP2_SUCCEEDED=true
declare -A OS_PKG_MANAGERS;
OS_PKG_MANAGERS[/etc/redhat-release]=dnf
OS_PKG_MANAGERS[/etc/arch-release]=pacman
OS_PKG_MANAGERS[/etc/gentoo-release]=emerge
OS_PKG_MANAGERS[/etc/SuSE-release]=zypper
OS_PKG_MANAGERS[/etc/debian_version]=apt-get

for OS_BASE in ${!OS_PKG_MANAGERS[@]};do
   if  [[ -f "${OS_BASE}" ]];then
      MY_PKG_MANAGER="${OS_PKG_MANAGERS[${OS_BASE}]}"
   fi
done

case ${MY_PKG_MANAGER} in
  "dnf" )
  sudo dnf install jq
  ;;
  "pacman" )
  sudo pacman -Sy jq
  ;;
  "zypper" )
  sudo zypper install jq
  ;;
  "apt-get" )
  sudo apt-get install jq
  ;;
  * )
  IS_STEP2_SUCCEEDED=false
esac
logByStepAndState "2" "${IS_STEP2_SUCCEEDED}"


if [[ ${SUCCESS_RATE} -eq ${TOTAL_STEPS} ]]; then
  echo "Done ✔"
  echo "🎉🎉🎉 GIT-MR has been installed successfully. Enjoy 🎉🎉🎉"
  else
    echo "🚨 Installation not complete! 🚨"
    echo "👉Please complete the remaining steps manually."
    echo "👉For more informations visit our github repository: https://github/MostafaACHRAF/Git-MR "
    echo "Remaining steps: [${remainingSteps[@]}]"
fi