#!/bin/bash

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

devops_git_merge () {
     git fetch
     git merge $@
}



# remaining functions
source ~/devops/bash_functions/devops_git_url_parse.sh
source ~/devops/bash_functions/devops_git_branch.sh
source ~/devops/bash_functions/devops_git_clone.sh
