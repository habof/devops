
# sometimes USER isn't set on windows
if [ ! -n "${USER}" ]; then
    USER=`basename ${HOME}` 
fi

 # sometimes HOSTNAME isn't set on windows
if [ ! -n "${HOSTNAME}" ]; then
    HOSTNAME=`hostname`
fi

source ~/devops/bash_functions/devops_git_branch.sh
