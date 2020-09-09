#!/bin/bash

#@Author : Mostafa ASHARF
#@Date (en) : 05/04/19
#@Last update (en) : 06/09/19
#@Version : 3.0
#Developed will listening to piano music \(^_^)/

VERSION=3.0
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
git clone https://github.com/MostafaACHRAF/Git-MR /bin && chmod +x /bin/Git-MR*.sh && .linux-install.sh



SRC_PATH="/bin/gitMR"
SRC_SCRIPT="git-lmr"
SRC_SCRIPT_PATH="${SRC_PATH}/${SRC_SCRIPT}"
PKG_MANAGER="NONO"
ZSH_CONF_PATH=~/.zshrc
BASH_CONF_PATH=~/.bashrc
ZSH_BASH_VAR_PATH="PATH=\$PATH:${SRC_PATH}"
ZSH_BASH_VAR_PATH_REGEX="PATH=\\\$PATH:${SRC_PATH//'/'/'\/'}"

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ UTILS FUNCTIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SUCCESS_RATE=0
TOTAL_STEPS=3
logByStepAndState() {
  #${1} : STEP ; ${2} : STATE
  case ${1} in
    "1" )
    if [[ "${2}" == true ]];then
      echo ">> [Result] : [${SRC_PATH}] has been created successfully..."
      echo ">> [Result] : [${SRC_SCRIPT_PATH}] has been copied successfully..."
      ((SUCCESS_RATE++))
      else
        echo ">> [Error] : Something went worng will creating [${SRC_PATH}] or copying [${SRC_SCRIPT_PATH}] !"
    fi
    ;;
    "2" )
    if [[ "${2}" == true ]];then
      echo ">> [Result] : The PATH environment variable of your shell has been updated successfully..."
      ((SUCCESS_RATE++))
      else
        echo ">> [Warning] : Actually we support only ZSH and BASH shells! Update you PATH variable manually add : [${SRC_SCRIPT_PATH}] !"
    fi
    ;;
    "3" )
    if [[ "${2}" == true  ]];then
      echo ">> [Result] : jq (json parser) has been installed successfully..."
      ((SUCCESS_RATE++))
      else
        printf "[Warning] : Sorry, We don't support your package manager yet!\nInstall 'jq' manually : [https://stedolan.github.io/jq/download/] !"
    fi
    ;;
  esac
  echo ">> [STATE] : SUCCESS STEPS = [${SUCCESS_RATE}/${TOTAL_STEPS}]..."
  if [[ ${SUCCESS_RATE} -eq ${TOTAL_STEPS}]]; then
    echo "(Git-MR) => has been installed successfully. Enjoy 🎉🎉🎉"
    else
      echo "Having trouble? Get help from : https://github.com/MostafaACHRAF/Git-MR"
  fi
}

appendStringToFile() {
  #${1} : STRING, ${2} : FILE_PATH
  if [[ -f "${2}" ]]; then
    if ! grep "${1}" "${2}"; then
      echo "${1}" >> "${2}"
      IS_STEP2_SUCCEEDED=true
    fi
  fi
}

removeVariablePathFrom() {
  #${1} : FILE_PATH
  echo ">> [Delete] : The variable path from : [${1}]..."
  sed -i 's/'"^${ZSH_BASH_VAR_PATH_REGEX}"'//g' "${1}"
}

configureOS4SrcScript() {
  echo ">> [Configure] : Add the OS : 'LINUX' to [${SRC_SCRIPT}]..."
  sudo sed -i -E 's/^(OS=).*/\1"LINUX"/g' "${SRC_SCRIPT_PATH}"
}

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ MAIN FUN @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IS_STEP1_SUCCEEDED=false
IS_STEP2_SUCCEEDED=false
IS_STEP3_SUCCEEDED=false

#Copy ${SRC_SCRIPT} to ${SRC_PATH}
if [[ -d "${SRC_PATH}" ]]; then
  read -p ">> [Warning] : Auto.Git.Mr already installed ! would you like to reinstall it [y/n]?" RESPONSE
  echo "RESPONSE = ${RESPONSE}"
  if [[ "${RESPONSE}" == "y" || "${RESPONSE}" == "Y" ]]; then
    sudo rm -rf "${SRC_PATH}"
    removeVariablePathFrom "${ZSH_CONF_PATH}"
    removeVariablePathFrom "${BASH_CONF_PATH}"
    echo ">> [Result] : Auto.Git.Mr has been removed successfully..."
  fi
fi

if [[ ! -d "${SRC_PATH}" ]];then
  sudo mkdir "${SRC_PATH}"
  sudo cp "${SRC_SCRIPT}" "${SRC_PATH}"
  if [[ -f "${SRC_SCRIPT_PATH}" ]]; then
    configureOS4SrcScript
    IS_STEP1_SUCCEEDED=true
  fi
  logByStepAndState "1" "${IS_STEP1_SUCCEEDED}"
fi

#Add ${SRC_PATH} to path [~/.zshrc, and ~/.bashrc]
#ToDo...for Other SHELLs [$KSH_VERSION,$FCEDIT,$PS3]
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${ZSH_CONF_PATH}"
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${BASH_CONF_PATH}"
logByStepAndState "2" "${IS_STEP2_SUCCEEDED}"

#Download and install jq on [debian-base, and other distros...]
IS_STEP3_SUCCEEDED=true
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
  IS_STEP3_SUCCEEDED=false
esac
logByStepAndState "3" "${IS_STEP3_SUCCEEDED}"
