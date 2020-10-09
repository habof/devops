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
    exit 2
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
    return 2
}
devops_return_rc () {
    rc=${1}
    shift 1
    echo "$@"
    return ${rc}
}

# remaining functions
source ~/devops/bash_functions/devops_git_url_parse.sh
source ~/devops/bash_functions/devops_git_branch.sh
source ~/devops/bash_functions/devops_git_clone.sh
source ~/devops/bash_functions/devops_git_merge.sh

# setup (last due to dependencies)
source ~/devops/bash_functions/devops_setup.sh
