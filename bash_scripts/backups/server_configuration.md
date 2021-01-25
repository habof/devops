* Create a git organization
* Create a git service account and add it to the organization as an owner
* In the organization, create a git repository for configuration backups
* Configure root with the git user information
  ```bash
  cd /root
  git config --global user.email "your-git-service-account-email-address"
  git config --global user.name "your-git-service-account-name"
  ```
* Configure root with keys (see https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
  ```bash
  cd /root
  ssh-keygen -C "your_email@example.com"
  ```
  * add key to service account user on github (https://github.com/settings/ssh/new)
* Clone the repository within the root folder
  ```bash
  cd /root
  git clone your-clone-url .server-conf-backup
  ```
* Make sure /root/.profile contains this
  ```bash
  if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
      . ~/.bashrc
    fi
  fi  
  ```
* Create a backup script script as root
  ```bash
  mkdir -p /root/.server-conf-backup/scripts
  touch /root/.server-conf-backup/scripts/server_configuration.sh
  ```
* Edit script (or similar to meet your needs) as root
  ```bash
  vi /root/.server-conf-backup/scripts/server_configuration.sh
  ```
  ```bash
  #!/bin/bash
  rsync -av /etc /root/.server-conf-backup
  crontab -l > /root/.server-conf-backup/crontab_root
  apt list --installed > /root/.server-conf-backup/apt.list
  pip3 list > /root/.server-conf-backup/pip.list
  df -h > /root/.server-conf-backup/space.txt
  cd /root/.server-conf-backup
  git add *
  git add -u
  git commit -m"backup configuration"
  git push
  ```
* Commit script as root and push
  ```bash
  chmod gou+x /root/.server-conf-backup/scripts/server_configuration.sh
  cd /root/.server-conf-backup
  git add scripts/server_configuration.sh
  git commit -m"backup script update"
  git push
  ```
* Schedule this script in the root crontab
  ```bash
  # m h  dom mon dow   command
  0 5 * * * /root/.server-conf-backup/scripts/server_configuration.sh
  ```
