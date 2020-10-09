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

