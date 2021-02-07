
devops_git_get_latest () {
# Usage: devops_git_get_latest branch
# This will merge in commits to the branch you are in from the specified PRODUCTION branch
current_branch=`devops_git_parse_branch`
while true; do
    read -p "
        You are about to merge ${1} into ${current_branch}
        * ${current_branch} should be a PRODUCTION environment branch like prod, main or master!!!
        * ${1} should be a feature branch!!!
        Do you wish to continue?
        (y/n)
        " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) git checkout ${current_branch}; return 2 ;;
        * ) echo "Please answer yes or no.";;
    esac
done
     git fetch
     git merge origin/${1}
}