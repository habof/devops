#!/bin/bash
devops_git_clone() {
    
# The help text / documentation
help_text="

Usage: devops_git_clone [options...]

-u, --url=        *** Required *** i.e. https://github.com/habof/devops.git or git@github.com:habof/devops.git

-b, --branch=     Name of branch to clone from 

-p, --path=       Path where clone folders reside, i.e. ${HOME}/code or ${HOME}/repos or ${HOME}/git if not specified, 
                    looks in ${DEVOPS_GIT_CLONE_PATH}, then defaults to ${HOME}

-s, --style         Looks in ${DEVOPS_GIT_CLONE_STYLE}, then defaults to namespace.

					Styles which start with branch- assume the branch already exists and that you will not be switching branches 
						because you like to work on multiple branches simulaneously without switching a folder's branch

                    Examples for --url=https://github.com/habof/devops.git --branch=issue-1234 --path=${HOME}/code 

                    folder:  
						i.e. ${HOME}/code/github.com/habof/devops 
                    folder-no-host:  
						i.e. ${HOME}/code/habof/devops 
                    folder-simple:  
						i.e. ${HOME}/code/devops 
					
					
                    branch-folder: 
						i.e. ${HOME}/code/issue-1234/github.com/habof/devops					
                    branch-folder-no-host: 
						i.e. ${HOME}/code/issue-1234/habof/devops
                    branch-folder-simple:  
						i.e. ${HOME}/code/issue-1234/devops 

					namespace:  
						i.e. ${HOME}/code/github.com.habof.devops 
					namespace-no-host:  
						i.e. ${HOME}/code/habof.devops 

                    branch-namespace:  
						i.e. ${HOME}/code/issue-1234.github.com.habof.devops 
                    branch-namespace-no-host:  
						i.e. ${HOME}/code/issue-1234.devops 

-d, --delete      This will delete the clone folder!!!!!
                                        
-h, --help    
"

# unset and default vars
unset url
unset branch
[ ! -n "${DEVOPS_GIT_CLONE_PATH}" ] || path=${DEVOPS_GIT_CLONE_PATH}
[ -n "${path}" ] || path=${HOME}
[ ! -n "${DEVOPS_GIT_CLONE_STYLE}" ] || style=${DEVOPS_GIT_CLONE_STYLE}
[ -n "${style}" ] || style=namespace
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
    devops_return_success "$help_text"
    ;;
    *)
	devops_return_error "Invalid argument"
esac
shift
done

# echo arguments
echo "--url: ${url}"
echo "--branch: ${branch}"
echo "--path: ${path}"
echo "--style: ${style}"
${delete} && echo "--delete: true"

# validate arguments
[ -n "${url}" ] || return devops_return_error "url argument required"
[ -n "${path}" ] || return devops_return_error "path argument required"
[ -n "${style}" ] || return devops_return_error "style argument required"
# [ -n "${branch}" ] || return devops_return_error "branch argument required"

name=`devops_git_url_parse ${url} name`
dirshort=`devops_git_url_parse ${url} dirshort`
dirlong=`devops_git_url_parse ${url} dirlong`

mkdir -p ${path}
cd_to=${path}
clone_as=${name}
add_branch=" --branch ${branch}"
case "${style}" in
	folder)
		cd_to="${path}/${dirlong}"
		add_branch=""
	;;
	folder-no-host)
		cd_to="${path}/${dirshort}"
		add_branch=""
	;;
	folder-simple)
		cd_to="${path}"
		add_branch=""
	;;
	branch-folder)
		cd_to="${path}/${branch}/${dirlong}"
		add_branch=""
	;;
	branch-folder-no-host)
		cd_to="${path}/${branch}/${dirshort}"
	;;
	branch-folder-simple)
		cd_to="${path}/${branch}"
	;;
	namespace)
		clone_as=`echo "${dirlong}/${name}" | tr / .`
		add_branch=""
	;;
	namespace-no-host)
		clone_as=`echo "${dirshort}/${name}" | tr / .`
		add_branch=""
	;;
	branch-namespace)
		clone_as=`echo "${branch}/${dirlong}/${name}" | tr / .`
	;;
	branch-namespace-no-host)
		clone_as=`echo "${branch}/${dirshort}/${name}" | tr / .`
	;;
	*)
	return devops_return_error "style argument invalid"
esac
     

echo "cd_to: ${cd_to}"
echo "clone_as: ${clone_as}"


clone_cmd="git clone${add_branch} ${url} ${clone_as}"
echo "clone into: ${cd_to}"
echo "clone command: ${clone_cmd}"

mkdir -p ${cd_to}
calling_path=`pwd -P`
echo "saving your location (${calling_path})"
cd ${cd_to}
pwd
${clone_cmd} 2>/dev/null
cd ${cd_to}/${clone_as}
pwd
git status
echo "returning you to (${calling_path})"
cd ${calling_path}


}