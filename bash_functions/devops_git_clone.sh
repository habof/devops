#!/bin/bash
devops_git_clone() {
    
# The help text / documentation
help_text="

Usage: devops_git_clone [options...]

-u, --url=        *** Required *** i.e. https://github.com/habof/devops.git or git@github.com:habof/devops.git

-b, --branch=     *** Required *** i.e. https://github.com/habof/devops.git or git@github.com:habof/devops.git

-p, --path=       Path where clone folders reside, i.e. ${HOME}/code or ${HOME}/repos or ${HOME}/git if not specified, 
                    looks in ${DEVOPS_GIT_CLONE_PATH}, then defaults to ${HOME}

-s, --style       (namespace, folder, branch-namespace, branch-folders, branch-namespace-simple, branch-folders-simple)
                    Looks in ${DEVOPS_GIT_CLONE_STYLE}, then defaults to namespace.

					Styles which start with branch- assume the branch already exists and that you will not be switching branches 
						because you like to work on multiple branches simulaneously without switching a folder's branch

                    Examples for --url=https://github.com/habof/devops.git --branch=issue-1234 --path=${HOME}/code 
                    namespace:  
						i.e. ${HOME}/code/github.com.habof.devops 
                    folder:  
						i.e. ${HOME}/code/github.com/habof/devops 
                    folder-simple:  
						i.e. ${HOME}/code/devops 
                    branch-namespace:  
						i.e. ${HOME}/code/issue-1234.github.com.habof.devops 
                    branch-folders: 
						i.e. ${HOME}/code/issue-1234/github.com/habof/devops
                    branch-namespace-simple:  
						i.e. ${HOME}/code/issue-1234.devops 
                    branch-folders-simple:  
						i.e. ${HOME}/code/issue-1234/devops 

-d, --delete      This will delete the clone folder!!!!!
                                        
-h, --help    
"

# unset and default vars
unset url
unset branch
[ ! -n "${DEVOPS_GIT_CLONE_PATH}" ] || path=${DEVOPS_GIT_CLONE_PATH}
[ -n "${path}" ] || path=${HOME}
[ ! -n "${DEVOPS_GIT_CLONE_STYLE}" ] || style=${DEVOPS_GIT_CLONE_STYLE}
[ -n "${style}" ] || style=folder
delete=false

# get arguments into vars
while [ $# -gt 0 ]; do
case "${1}" in
	--url=*)
	url="${1#*=}"
	;;
	-e)
	url="${2}"
    shift
	;;
	--branch=*)
	branch="${1#*=}"
	;;
	-s)
	branch="${2}"
    shift
	;;
	--path=*)
	path="${1#*=}"
	;;
	-a)
	path="${2}"
    shift
	;;
	--style=*)
	style="${1#*=}"
	;;
	-b)
	style="${2}"
    shift
	;;
	-f|--delete)
	delete=true
	;;
    -h|--help)
    echo "$help_text"
    ;;
    *)
	echo "Invalid argument"
esac
shift
done

# validate arguments
[ -n "${url}" ] || echo "url argument required"
[ -n "${branch}" ] || echo "branch argument required"
[ -n "${path}" ] || echo "path argument required"
[ -n "${style}" ] || echo "style argument required"

# echo arguments
echo "--url: ${url}"
echo "--branch: ${branch}"
echo "--path: ${path}"
echo "--style: ${style}"
${delete} && echo "--delete: true"


}