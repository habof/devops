
* Make sure /root/.profile contains this
  ```bash
  if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
      . ~/.bashrc
    fi
  fi  
  ```
* Create and run this script (or similar to meet your needs) as root
  ```bash
  #!/bin/bash
  backup_path="/path/to/where/you/want/backups"

  source /root/.profile
  date=$(date +"%Y-%m-%d-%H-%M-%S")
  mkdir -p ${backup_path}
  umask 177 ${backup_path}
  mysqldump --all-databases --single-transaction --skip-lock-tables | gzip > ${backup_path}/${date}.sql.gz
  ```
* Schedule this script in the root crontab
  ```bash
  # m h  dom mon dow   command
  0 5 * * * /devops/bash_scripts/backups/mysql.sh
  ```
