#!/bin/bash

gitProjects="${configDir}/git.projects"

if [[ ! -f "${gitProjects}" ]]; then printf "" > "${gitProjects}"; fi

createNewProject() {
    # ${1} : project uid
    printf "\n==> Create new project alias for [${1}] git project...\n"
    read -p "> [Git project name]:" GIT_PROJECT_NAME
    read -p "> [Git project id]:" GIT_PROJECT_ID
    configDir="${configDir}" node ${utilsDir}/vcs_menu/menu.js
    vcs=$(cat ${configDir}/menu.log)
    projectAlreadyExist=$(awk -F/ '$1 == "=>'${1}':" {print "exist"; exit 0}' ${gitProjects})
    if [[ -z "${projectAlreadyExist}" ]]; then
        printf "==> Create new git project configuration..."
        printf "\n" >> "${gitProjects}"
        printf "=>${1}:\n" >> "${gitProjects}"
        printf "${1}_project_name=${GIT_PROJECT_NAME}\n" >> "${gitProjects}"
        printf "${1}_project_id=${GIT_PROJECT_ID}\n" >> "${gitProjects}"
        printf "${1}_vcs=${vcs}\n" >> "${gitProjects}"
        printf "<=\n" >> "${gitProjects}"
        else
            printf "==> Update [${1}] gitlab project configuration..." 
            sed -i -E 's/'"(${1}_project_name=).*"'/\1'"${GIT_PROJECT_NAME//\//\\/}"'/g' "${gitProjects}"
            sed -i -E 's/'"(${1}_project_id=).*"'/\1'"${GIT_PROJECT_ID//\//\\/}"'/g' "${gitProjects}"
            sed -i -E 's/'"(${1}_vcs=).*"'/\1'"${vcs}"'/g' "${gitProjects}"
    fi
    if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
}

removeProject() {
    # ${1} : project uid
    projectFound=$(awk -F/ '$1 == "=>'${1}':" {print "exist"; exit 0}' ${gitProjects})
    if [[ ! -z "${projectFound}" ]]; then
        read -p "Remove this [${1}] git configuration? [y/n]:" response 
        case "${response}" in
        [yY]*)
            printf "==> Remove [${1}] git configuration..."
            sed -i -E '/=>'${1}':/,/<=/d' "${gitProjects}"
            if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
        ;;
    esac
        else
            printf "Error! Project not found!\n"
    fi
}

removeAllProjects() {
    read -p "Remove all projects git configurations? [y/n]:" response
    case "${response}" in
        [yY]*)
        printf "==> Remove all git projects configuration..."
        printf "" > "${gitProjects}"
        if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
    esac
}

help() {
    printf "Alias not found!\n"
    printf "Invalid command!\n"
    printf "Possible options:\n"
    printf "  --new {project_uid}\n"
    printf "  --rm {project_uid}\n"
    printf "  --remove-all\n"
}

listAllProjects() {
    projects=()
    while read line; do
        if [[ "${line}" =~ \=\>.+: ]]; then
            line=${line//=>/}
            line=${line//:/}
            projects+=("${line}")
        fi
    done < "${gitProjects}"
    result=$(echo "${projects[@]}")
    printf "${result// /\\n}\n"
}


params=()

for arg in "$@"; do
    params+=("$arg")
done

for i in "${!params[@]}"; do
    case "${params[$i]}" in
        --new)
        if [[ -z "${params[$i + 1]}" ]]; then help; exit 1; fi
        createNewProject "${params[$i + 1]}"
        exit 0
        ;;
        --rm)
        if [[ -z "${params[$i + 1]}" ]]; then help; exit 1; fi
        removeProject "${params[$i + 1]}"
        exit 0
        ;;
        --remove-all)
        removeAllProjects
        exit 0
        ;;
        --all)
        listAllProjects
        exit 0
        ;;
        *)
        printf "\n🚨 Error! command not found! 🚨\n"
        ;;
    esac
done