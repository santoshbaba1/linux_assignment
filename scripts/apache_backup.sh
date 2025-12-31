# !/bin/bash
 DATE=$(date +%F_%H-%M-%S)
 BACKUP_FILE="/backups/apache_backup_$DATE.tar.gz"
 LOG_FILE="/backups/apache_backup.log"
 APACHE_CONF="-C / etc/httpd"
 APACHE_DOCROOT="-C / var/www/html"
 echo "===== Apache Backup Started: $(date) =====" >> $LOG_FILE
 tar -czf $BACKUP_FILE $APACHE_CONF $APACHE_DOCROOT 2>> $LOG_FILE
 if tar -tzf $BACKUP_FILE > /dev/null 2>> $LOG_FILE; then
        echo "Backup Verified Successfully: $BACKUP_FILE" >> $LOG_FILE
 else
        echo "Backup Verification FAILED !" >> $LOG_FILE
 fi
 echo "===== Apache Backup Completed =====" >> $LOG_FILE
 echo "" >> $LOG_FILE
