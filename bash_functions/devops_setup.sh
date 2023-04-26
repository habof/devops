
devops_setup() {
    # SSH 
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
}
