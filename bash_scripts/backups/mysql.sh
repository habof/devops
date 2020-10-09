#!/bin/bash
backup_path="/path/to/where/you/want/backups"

source /root/.profile
date=$(date +"%Y-%m-%d-%H-%M-%S")
mkdir -p ${backup_path}
umask 177 ${backup_path}
mysqldump --all-databases --single-transaction --skip-lock-tables | gzip > ${backup_path}/${date}.sql.gz
