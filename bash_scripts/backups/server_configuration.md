* Create a git repository for configuration backups
* Create a git service account for root and give it access to the repository
* Configure root with the git user information
  ```bash
  cd /root
  git config --global user.email "your-git-service-account-email-address"
  git config --global user.name "your-git-service-account-name"
  ```
* Clone the repository within the root folder
  ```bash
  cd /root
  git clone your-clone-url .server-conf-backup
  ```
* Create and run this script (or similar to meet your needs) as root
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
* Schedule this script in the root crontab
  ```bash
  # m h  dom mon dow   command
  0 5 * * * /devops/bash_scripts/backups/server_configuration.sh
  ```
