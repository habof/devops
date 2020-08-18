
# sometimes USER isn't set on windows
if [ ! -n "${USER}" ]; then
    USER=`basename ${HOME}` 
fi

 # sometimes HOSTNAME isn't set on windows
if [ ! -n "${HOSTNAME}" ]; then
    HOSTNAME=`hostname`
fi

devops_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1)'
}