#!/bin/bash
devops_git_clone() {
    
valid_styles=( \
path-exact \
folder \
folder-no-host \
folder-simple \
branch-folder \
branch-folder-no-host \
branch-folder-simple \
namespace \
namespace-no-host \
branch-namespace \
branch-namespace-no-host \
)
valid_branch_styles=( \
branch-folder \
branch-folder-no-host \
branch-folder-simple \
branch-namespace \
branch-namespace-no-host \
)
valid_workspace_types=( \
vscode \
)

# unset and default vars
unset url
unset branch
[ ! -n "${DEVOPS_GIT_CLONE_PATH}" ] || path=${DEVOPS_GIT_CLONE_PATH}
[ -n "${path}" ] || path=${HOME}
[ ! -n "${DEVOPS_GIT_CLONE_STYLE}" ] || style=${DEVOPS_GIT_CLONE_STYLE}
[ -n "${style}" ] || style=namespace

# The help text / documentation
help_text="

Usage: devops_cmd_for_git_clone [options...]

-u, --url=        
	*** Required *** i.e. https://github.com/habof/devops.git or git@github.com:habof/devops.git

-b, --branch=     
	Name of branch to clone from 

-p, --path=       
	Path where clone folders reside, i.e. /path/to/code or /path/to/repos or /path/to/git

    If not specified, looks in your settings for DEVOPS_GIT_CLONE_PATH
	
	Defaults to to your HOME directory

-s, --style=       
    Valid values: ${valid_styles[@]}

	Looks in in your settings for DEVOPS_GIT_CLONE_STYLE

	Defaults to ${style}

	Styles which start with branch- assume the branch already exists and that you will not be switching branches because you like to work on multiple branches simulaneously without switching a folder's branch

	Example repository locations for --url=https://github.com/habof/devops.git --branch=issue-1234 --path=${HOME}/code 
	
	path-exact:  
		i.e. /path/to/code 

	folder:  
		i.e. /path/to/code/github.com/habof/devops 
	folder-no-host:  
		i.e. /path/to/code/habof/devops 
	folder-simple:  
		i.e. /path/to/code/devops 
		
	branch-folder: 
		i.e. /path/to/code/issue-1234/github.com/habof/devops					
	branch-folder-no-host: 
		i.e. /path/to/code/issue-1234/habof/devops
	branch-folder-simple:  
		i.e. /path/to/code/issue-1234/devops 

	namespace:  
		i.e. /path/to/code/github.com.habof.devops 
	namespace-no-host:  
		i.e. /path/to/code/habof.devops 

	branch-namespace:  
		i.e. /path/to/code/issue-1234.github.com.habof.devops 
	branch-namespace-no-host:  
		i.e. /path/to/code/issue-1234.devops 

-w, --workspace-type=     
	Add a workspace to repository
	Valid values: ${valid_workspace_types[@]}

-h, --help    
"

# get arguments into vars
while [ $# -gt 0 ]; do
case "${1}" in
	--url=*)
	url="${1#*=}"
	;;
	-u)
	url="${2}"
    shift
	;;
	--branch=*)
	branch="${1#*=}"
	;;
	-b)
	branch="${2}"
    shift
	;;
	--path=*)
	path="${1#*=}"
	;;
	-p)
	path="${2}"
    shift
	;;
	--style=*)
	style="${1#*=}"
	;;
	-s)
	style="${2}"
    shift
	;;
	--workspace-type=*)
	workspace_type="${1#*=}"
	;;
	-w)
	workspace_type="${2}"
    shift
	;;
    -h|--help)
    devops_return_success "$help_text" && return 0
    ;;
    *)
	devops_return_error "Invalid argument" || return 1
esac
shift
done

# validate arguments
[ -n "${url}" ] || devops_return_error "url argument required" || return 1
[ -n "${path}" ] || devops_return_error "path argument required" || return 1
[ -n "${style}" ] || devops_return_error "style argument required" || return 1

unset is_valid_style
for a in "${valid_styles[@]}" ; do
     [ "$a" == "${style}" ] && is_valid_style=0
done
[[ $is_valid_style && ${is_valid_style-x} ]] || devops_return_error "invalid style argument" || return 1

for a in "${valid_branch_styles[@]}" ; do
	if [ "$a" == "${style}" ]; then 
	    [ -n "${branch}" ] || devops_return_error "branch required for style ${style}" || return 1
	fi
done

if [ -n "${workspace_type}" ]; then
    unset is_valid_workspace_type
	for a in "${valid_workspace_types[@]}" ; do
		[ "$a" == "${workspace_type}" ] && is_valid_workspace_type=0
	done
	[[ $is_valid_workspace_type && ${is_valid_workspace_type-x} ]] || devops_return_error "invalid workspace-type argument" || return 1
fi

repository_name=`devops_git_url_parse ${url} name`
dirshort=`devops_git_url_parse ${url} dirshort`
dirlong=`devops_git_url_parse ${url} dirlong`

clone_path_parent=${path}
clone_folder=${repository_name}
case "${style}" in
	path-exact)
	    clone_path_parent="$(dirname $path)"   
        clone_folder="$(basename $path)"  
	;;
	folder)
		clone_path_parent="${path}/${dirlong}"
	;;
	folder-no-host)
		clone_path_parent="${path}/${dirshort}"
	;;
	folder-simple)
		clone_path_parent="${path}"
	;;
	branch-folder)
		clone_path_parent="${path}/${branch}/${dirlong}"
	;;
	branch-folder-no-host)
		clone_path_parent="${path}/${branch}/${dirshort}"
	;;
	branch-folder-simple)
		clone_path_parent="${path}/${branch}"
	;;
	namespace)
		clone_folder=`echo "${dirlong}/${repository_name}" | tr / .`
	;;
	namespace-no-host)
		clone_folder=`echo "${dirshort}/${repository_name}" | tr / .`
	;;
	branch-namespace)
		clone_folder=`echo "${branch}/${dirlong}/${repository_name}" | tr / .`
	;;
	branch-namespace-no-host)
		clone_folder=`echo "${branch}/${dirshort}/${repository_name}" | tr / .`
	;;
esac
add_branch=""
clone_directory="${clone_path_parent}/${clone_folder}"
[ -n "${branch}" ] && add_branch=" --branch ${branch}"     
clone_command="git clone${add_branch} ${url} ${clone_folder}"
echo "clone_path_parent: ${clone_path_parent}"
echo "clone_directory: ${clone_directory}"
echo "clone_command: ${clone_command}"

calling_path=`pwd -P`
echo "saving your location (${calling_path})"
mkdir -p "${clone_path_parent}"
cd "${clone_path_parent}"
${clone_command} 2>/dev/null
cd "${clone_directory}"

[ -n "${workspace_type}" ] && {
case "${workspace_type}" in
	vscode)
	    echo "{\"folders\":[{\"name\": \"${repository_name}\",\"path\": \"${clone_folder}\"}]}" > "${clone_path_parent}/${clone_folder}.code-workspace"
	;;
esac
}

pwd
git status
echo "returning you to (${calling_path})"
cd ${calling_path}




}