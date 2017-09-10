#!/usr/local/bin/bash

# Environment variables

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin

# Retention days
DAYS="7"

EXPIREDATE=$(date -j -v-"$DAYS"d +"%Y%m%d");

FILE=mysiteWWW`date +"%Y%m%d"`
DUMP=mysitedb`date +"%Y%m%d"`

### Troubleshooting ###
#set echo
#set verbose

/usr/local/bin/mysqldump -uroot mysitedb > /root/gdrive/$DUMP.sql
/usr/local/bin/7z a /root/gdrive/$FILE.7z /usr/local/www/mysite

# Delete old backups
find /root/gdrive/*.sql -mtime +7 -exec rm {} \;
find /root/gdrive/*.7z -mtime +7 -exec rm {} \;

# As bash doesn't really change the directory we use a function

# Function declaration
jhome () {
  cd /root/gdrive
}
# Function invocation
jhome

/usr/local/bin/drive push -destination backups/files -quiet $FILE.7z
/usr/local/bin/drive push -destination backups/files -quiet $DUMP.sql

/usr/local/bin/drive delete -quiet backups/docker/mysite$EXPIREDATE.7z
/usr/local/bin/drive delete -quiet backups/docker/mysitedb$EXPIREDATE.sql
