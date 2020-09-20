#!/bin/bash

#@Author : Mostafa ASHARF
#@Date (en) : 05/04/19
#@Last update (en) : 15/09/20
#@Version : 4.0
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
SRC_PATH="/bin/GitMR"
PKG_MANAGER="NONO"
ZSH_CONF_PATH=~/.zshrc
BASH_CONF_PATH=~/.bashrc
ZSH_BASH_VAR_PATH="PATH=\$PATH:${SRC_PATH}"
# ZSH_BASH_VAR_PATH_REGEX="PATH=\\\$PATH:${SRC_PATH//'/'/'\/'}"

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ UTILS FUNCTIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SUCCESS_RATE=0
TOTAL_STEPS=2
remainingSteps=()

logByStepAndState() {
  #${1} : STEP ; ${2} : STATE
  case ${1} in
    "1" )
    if [[ "${2}" == true ]];then
      ((SUCCESS_RATE++))
      else
        echo "🚨 Error! Unsupported script shell. We support only ZSH and BASH shell scripts 🚨"
        remainingSteps+=("👉 Add [${SRC_PATH}] to your variable PATH.")
    fi
    ;;
    "2" )
    if [[ "${2}" == true  ]];then
      ((SUCCESS_RATE++))
      else
        echo "🚨 Error! Looks like your package manager is not supported, or something went wrong will installing [jq]. 🚨"
        remainingSteps+=("👉 Install [jq] manually: https://stedolan.github.io/jq/download/")
    fi
    ;;
  esac
  echo "Step(${SUCCESS_RATE}/${TOTAL_STEPS}) Done ✔"
}

appendStringToFile() {
  #${1} : STRING, ${2} : FILE_PATH
  if [[ -f "${2}" ]]; then
    if ! grep "${1}" "${2}"; then
      echo "${1}" >> "${2}"
    fi
    if [[ $? == 0 ]]; then IS_STEP1_SUCCEEDED=true; fi
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

#Add ${SRC_PATH} to path [~/.zshrc, and ~/.bashrc]
#ToDo...for Other SHELLs [$KSH_VERSION,$FCEDIT,$PS3]
printf "\n"
echo "==> Update PATH variable..."
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${ZSH_CONF_PATH}"
appendStringToFile "${ZSH_BASH_VAR_PATH}" "${BASH_CONF_PATH}"
logByStepAndState "1" "${IS_STEP1_SUCCEEDED}"

#Download and install jq on [debian-base, and other distros...]
IS_STEP2_SUCCEEDED=true
PKG_MANAGERS=("/etc/redhat-release:dnf" "/etc/arch-release:pacman" "/etc/gentooo-release:emerge" "/etc/SuSE-release:zypper" "/etc/debian_version:apt-get")

for pkgManager in "${PKG_MANAGERS[@]}"; do
   if [[ -f "${pkgManager%%:*}" ]]; then
    userId=$(id -u)
    cmd0=$(if [[ ${userId} -eq 0 ]]; then echo ""; else echo "sudo "; fi)
    cmd1=$(if [[ ${pkgManager##*:} == "pacman" ]]; then echo "-S"; else echo "install"; fi)
    jqInstaller="${cmd0}${pkgManager##*:} ${cmd1} jq"
    printf "\n"
    echo "==> Run ${jqInstaller}..."
    ${jqInstaller}
    break
   fi
done

jq --version
if [[ $? != 0 ]]; then IS_STEP2_SUCCEEDED=false; fi

logByStepAndState "2" "${IS_STEP2_SUCCEEDED}"

printf "\n"
if [[ ${SUCCESS_RATE} -eq ${TOTAL_STEPS} ]]; then
  echo "🎉🎉🎉 GIT-MR has been installed successfully. Enjoy 🎉🎉🎉"
  else
    echo "🚨 Installation not complete! 🚨"
    echo "👉Please complete the remaining steps manually."
    echo "👉For more informations visit our github repository: https://github/MostafaACHRAF/Git-MR "
    echo "Remaining steps: [${remainingSteps[@]}]"
fi
printf "\n"