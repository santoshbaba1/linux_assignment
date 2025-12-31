# !/bin/bash

 DATE=$(date +%F_%H-%M-%S)

 BACKUP_FILE="/backups/nginx_backup_$DATE.tar.gz"

 LOG_FILE="/backups/nginx_backup.log"

 NGINX_CONF="-C / etc/nginx"

 NGINX_DOCROOT="-C / usr/share/nginx/html"

 echo "===== Nginx Backup Started: $(date) =====" >> $LOG_FILE

 tar -czf $BACKUP_FILE $NGINX_FILE $NGINX_DOCROOT 2>> $LOG_FILE

 if tar -tzf $BACKUP_FILE > /dev/null 2>> $LOG_FILE; then
        echo "Backup Verified Successfully:$BACKUP_FILE" >> $LOG_FILE
 else
        echo "Backup Verification FAILED !" >> $LOG_FILE
 fi

 echo "===== Nginx Backup Completed =====" >> $LOG_FILE

 echo "" >> $LOG_FILE
~
