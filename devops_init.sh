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
devops_git_merge () {
     git fetch
     git merge $@
}

# remaining functions
source ~/devops/bash_functions/devops_git_branch.sh
source ~/devops/bash_functions/devops_git_clone.sh
