#!/bin/bash

gitProjects="../conf/git.projects"

if [[ ! -f "${gitProjects}" ]]; then printf "" > "${gitProjects}"; fi

githubFields=(alias username token owner repo)
gitlabFields=(alias username project_name token project_id)

getFormatedFieldValue() {
    fieldName=${1}
    data=${2}
    value=`echo "${data}" | jq ."${fieldName}"`
    echo "${value//\"/}"
}

startNewAlias() {
    alias="${1}"
    printf "\n=>${alias}:\n" >> "${gitProjects}"
}

endNewAlias() {
    printf "<=\n" >> "${gitProjects}"
}

createOrUpdateAliasFields() {
    data=${1}
    vcs=${2}
    action=${3}

    if [[ "${vcs}" == "github" ]]; then fields=("${githubFields[@]}"); else fields=("${gitlabFields[@]}"); fi
    alias=$(getFormatedFieldValue "alias" "${data}")

    for field in "${fields[@]}"; do
        fieldValue=$(getFormatedFieldValue "$field" "$data")
        if [[ "${action}" == "add" ]]; then
            printf "==> Add [${field}] to [${alias}] alias..."
            printf "${alias}_${field}=${fieldValue}\n" >> "${gitProjects}"
            else
                printf "==> Update [${field}] in [${alias}] alias..."
                sed -i -E 's/'"(${alias}_${field}=).*"'/\1'"${fieldValue//\//\\/}"'/g' "${gitProjects}"
        fi
        if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
    done
}

createGitProjectAlias() {
    data="${1}"
    alias=$(getFormatedFieldValue "alias" "${data}")
    vcs=$(getFormatedFieldValue "vcs" "${data}")
    aliasAlreadyExist=$(awk -F/ '$1 == "=>'${alias}':" {print "exist"; exit 0}' ${gitProjects})
    if [[ -z "${aliasAlreadyExist}" ]]; then startNewAlias "${alias}"; action="add"; else action="update"; fi

    if [[ "${vcs}" != "github" && "${vcs}" != "gitlab" ]]; then printf "🚨 Error! Unsupported vcs: [$vcs]! 🚨\n"; exit 1; fi

    createOrUpdateAliasFields "${data}" "${vcs}" "${action}"

    if [[ "${action}" == "add" ]]; then endNewAlias; fi
}

removeProject() {
    # ${1} : project uid
    projectFound=$(awk -F/ '$1 == "=>'${1}':" {print "exist"; exit 0}' ${gitProjects})
    if [[ ! -z "${projectFound}" ]]; then
        read -p "Remove [${1}] alias configuration? [y/n]:" response 
        case "${response}" in
        [yY]*)
            printf "==> Remove [${1}] git configuration..."
            sed -i -E '/=>'${1}':/,/<=/d' "${gitProjects}"
            if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
        ;;
    esac
        else
            printf "🚨 Error! Project not found! 🚨\n"
    fi
}

removeAllProjects() {
    read -p "?Remove all projects git configurations? [y/n]:" response
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
        --new-alias)
        if [[ -z "${params[$i + 1]}" ]]; then help; exit 1; fi
        createGitProjectAlias "${params[$i + 1]}"
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
        printf "🚨 Error! command not found! 🚨\n"
        ;;
    esac
done