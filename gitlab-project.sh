#!/bin/bash

gitlabProjects="./gitlab.projects"

if [[ ! -f "${gitlabProjects}" ]]; then printf "" > "${gitlabProjects}"; fi

createNewProject() {
    # ${1} : project uid
    printf "\n"
    read -p "> [project name]:" GITLAB_PROJECT_NAME
    read -p "> [project id]:" GITLAB_PROJECT_ID
    node menu.js
    vcs=$(cat menu.log)
    projectAlreadyExist=$(awk -F/ '$1 == "=>'${1}':" {print "exist"; exit 0}' ${gitlabProjects})
    if [[ -z "${projectAlreadyExist}" ]]; then
        printf "==> Create new gitlab project configuration..."
        printf "\n" >> "${gitlabProjects}"
        printf "=>${1}:\n" >> "${gitlabProjects}"
        printf "${1}_project_name=${GITLAB_PROJECT_NAME}\n" >> "${gitlabProjects}"
        printf "${1}_project_id=${GITLAB_PROJECT_ID}\n" >> "${gitlabProjects}"
        printf "${1}_vcs=${vcs}\n" >> "${gitlabProjects}"
        printf "<=\n" >> "${gitlabProjects}"
        else
            printf "==> Update [${1}] gitlab project configuration..." 
            sed -i -E 's/'"(${1}_project_name=).*"'/\1'"${GITLAB_PROJECT_NAME//\//\\/}"'/g' "${gitlabProjects}"
            sed -i -E 's/'"(${1}_project_id=).*"'/\1'"${GITLAB_PROJECT_ID//\//\\/}"'/g' "${gitlabProjects}"
            sed -i -E 's/'"(${1}_vcs=).*"'/\1'"${vcs}"'/g' "${gitlabProjects}"
    fi
    if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
}

removeProject() {
    # ${1} : project uid
    projectFound=$(awk -F/ '$1 == "=>'${1}':" {print "exist"; exit 0}' ${gitlabProjects})
    if [[ ! -z "${projectFound}" ]]; then
        read -p "Remove this [${1}] gitlab configuration? [y/n]:" response 
        case "${response}" in
        [yY]*)
            printf "==> Remove [${1}] gitlab configuration..."
            sed -i -E '/=>'${1}':/,/<=/d' "${gitlabProjects}"
            if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
        ;;
    esac
        else
            printf "Error! Project not found!\n"
    fi
}

removeAllProjects() {
    read -p "Remove all projects gitlab configurations? [y/n]:" response
    case "${response}" in
        [yY]*)
        printf "==> Remove all gitlab projects configuration..."
        printf "" > "${gitlabProjects}"
        if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
    esac
}

help() {
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
    done < "${gitlabProjects}"
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
        ;;
        --rm)
        if [[ -z "${params[$i + 1]}" ]]; then help; exit 1; fi
        removeProject "${params[$i + 1]}"
        ;;
        --remove-all)
        removeAllProjects
        ;;
        --all)
        listAllProjects
        ;;
    esac
done