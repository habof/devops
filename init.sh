#!/bin/bash


# sometimes USER isn't set on windows
if [ ! -n "${USER}" ]; then
    USER=`basename ${HOME}` 
fi

 # sometimes HOSTNAME isn't set on windows
if [ ! -n "${HOSTNAME}" ]; then
    HOSTNAME=`hostname`
fi

# simple shared functions
devops_exit_success () {
    echo "$@"
    exit 0
}
devops_exit_error () {
    echo "$@"
    exit 1
}
devops_exit_rc () {
    rc=${1}
    shift 1
    echo "$@"
    exit ${rc}
}
devops_return_success () {
    echo "$@"
    return 0
}
devops_return_error () {
    echo "$@"
    return 1
}
devops_return_rc () {
    rc=${1}
    shift 1
    echo "$@"
    return ${rc}
}

# remaining functions
source ${DEVOPS_ROOT}/bash_functions/devops_git_url_parse.sh
source ${DEVOPS_ROOT}/bash_functions/devops_cmd_for_git_clone.sh
source ${DEVOPS_ROOT}/bash_functions/devops_git_url_parse.sh
source ${DEVOPS_ROOT}/bash_functions/devops_git_branch.sh
source ${DEVOPS_ROOT}/bash_functions/devops_git_clone.sh
source ${DEVOPS_ROOT}/bash_functions/devops_git_get_latest.sh
source ${DEVOPS_ROOT}/bash_functions/devops_git_merge_to_env.sh

# setup (last due to dependencies)
source ${DEVOPS_ROOT}/bash_functions/devops_setup.sh
