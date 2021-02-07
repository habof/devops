# Devops
* bash functions to make development easier 
* Sample server management scripts

## Prerequisites
* git installed OR [Git for Windows](https://gitforwindows.org/) (git bash) if you are using windows - make sure to be on the latest version
* Make sure ssh is set up
    ```
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    touch ~/.ssh/config
    ```    
* If you don't already have an id_rsa key pair (id_rsa and id_rsa.pub) in ~/.ssh then generate the pair without a passphrase (hit enter when prompted for the passphrase).
    ```
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
 
## Setup
* Clone this repo and note the clone location
* Add these lines at the end of ~/.bashrc and modify with your preferences and clone location
  ```
  # BEGIN devops settings for .bashrc
  DEVOPS_ROOT=/path/to/devops/clone
  DEVOPS_GIT_CLONE_PATH=${HOME}/github
  DEVOPS_GIT_CLONE_STYLE=branch-namespace

  export DEVOPS_GIT_CLONE_PATH
  export DEVOPS_GIT_CLONE_STYLE
  source ${DEVOPS_ROOT}/init.sh
  # END devops settings for .bashrc
  ```
