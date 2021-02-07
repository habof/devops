#!/bin/bash

devops_git_merge_to_env () {

current_branch=`devops_git_parse_branch`
while true; do
    read -p "
        You are about to merge ${current_branch} into ${1}
        * ${current_branch} should be a feature branch!!! 
        * ${1} should be an environment like dev, test, stage, prod, main or master!!!
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
git checkout ${1}

while true; do
    read -p "
        ${1} checked out.
        Do you wish to continue?
        (y/n)
        " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) 
            git checkout ${current_branch}; 
            return 2
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done

git pull --rebase 
while true; do
    read -p " 
        ARE THERE REBASE CONFLICTS from 'git pull --rebase on ${1}'? IF SO:
        * Review the conflicts and resolve appropriately (fix and commit conflicted files) 
        * When complete, continue here

        Do you wish to continue?
        (y/n)
        " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) 
            git rebase --abort 2>/dev/null
            git checkout ${current_branch}; 
            return 2
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done

git merge origin/${current_branch}

while true; do
    read -p "
        ARE THERE MERGE CONFLICTS from 'git merge origin/${current_branch}'? IF SO:
        * Review the conflicts and resolve appropriately (fix and commit conflicted files) 
        * If you have rename conflicts,
        * When complete, continue here

        Do you wish to continue?
        (y/n)
        " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) 
            echo "Aborting, returning you to ${current_branch}"
            git merge --abort 2>/dev/null
            git reset 2>/dev/null
            git checkout --force ${current_branch};
            return 2
        ;;
        * ) echo "Please answer yes or no.";;
    esac
done

git commit -m "Merge remote-tracking branch 'origin/${current_branch}' into ${1}"
git push 
echo "Merge Complete, Returning you to ${current_branch}"
git checkout ${current_branch};

}