#!/bin/bash
# Git Projects Manager

if [[ ! -f "${gitProjects}" ]]; then printf "" > "${gitProjects}"; fi

githubFields=(alias username token owner repo vcs)
gitlabFields=(alias username token projectId domainName repo vcs)

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

isAliasExist() {
    alias="${1}"
    awk -F/ '$1 == "=>'${alias}':" {print "exist"; exit 0}' ${gitProjects}
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
                if [[ ! -z "${fieldValue}" ]]; then
                    sed -i -E 's/'"(${alias}_${field}=).*"'/\1'"${fieldValue//\//\\/}"'/g' "${gitProjects}"
                fi
        fi
        if [[ $? == 1 ]]; then printf "Failed!\n"; exit 1; else printf "Done ✔️\n"; fi
    done
}

createOrUpdateGitProjectAlias() {
    data="${1}"
    alias=$(getFormatedFieldValue "alias" "${data}")
    vcs=$(getFormatedFieldValue "vcs" "${data}")
    aliasAlreadyExist=$(isAliasExist "${alias}")
    if [[ -z "${aliasAlreadyExist}" ]]; then startNewAlias "${alias}"; action="add"; else action="update"; fi

    if [[ "${vcs}" != "github" && "${vcs}" != "gitlab" ]]; then 
        log "error" "Error! Unsupported version control system [$vcs].";
        exit 1
    fi

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
            log "error" "Error! project alias not found."
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

listAllProjects() {
    projects=()
    while read line; do
        if [[ "${line}" =~ \=\>.+: ]]; then
            line=${line//=>/}
            line=${line//:/}
            vcs=`getAliasFieldValue "${line}" "vcs"`
            projects+=("${line}:(${vcs})")
        fi
    done < "${gitProjects}"
    result=$(echo "${projects[@]}")
    printf "${result// /\\n}\n"
}

getAliasFieldValue() {
    alias="${1}"
    field="${2}"
    if [[ -f "${configDir}/git.projects" && -s "${configDir}/git.projects" ]]; then
        while read line; do
            if [[ $line =~ ${alias}_${field}=.* ]]; then
                echo ${line##*=}
                break;
            fi
        done < "${configDir}/git.projects"
    fi
}

############################################################################################

params=()

for arg in "$@"; do
    params+=("$arg")
done

for i in "${!params[@]}"; do
    case "${params[$i]}" in
        -na)
            if [[ -z "${params[$i + 1]}" ]]; then log "error" "Error! project alias can't be empty."; exit 1; fi
            createOrUpdateGitProjectAlias "${params[$i + 1]}"
            exit 0
            ;;
        -rm)
            if [[ -z "${params[$i + 1]}" ]]; then log "error" "Error! project alias can't be empty."; exit 1; fi
            removeProject "${params[$i + 1]}"
            exit 0
            ;;
        --rm)
            removeAllProjects
            exit 0
            ;;
        --ls)
            listAllProjects
            exit 0
            ;;
        -get)
            getAliasFieldValue "${params[$i + 1]}" "${params[$i + 2]}"
            exit 0
            ;;
        -ae)
            isAliasExist "${params[$i + 1]}"
            exit 0
            ;;
        -getj)
            getFormatedFieldValue "${params[$i + 1]}" "${params[$i + 2]}"
            exit 0
            ;;
        *)
            log "error" "Error! command not found."
            exit 1
            ;;
    esac
done