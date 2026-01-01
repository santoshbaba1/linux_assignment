# linux_assignment
DevOps System Administration Report

System Monitoring, User Management, and Backup Configuration
Prepared By: Fresher DevOps Engineer
Environment: Linux Server
Users: Sarah and Mike

1. Introduction

This report documents the implementation of system monitoring, user management, access control, and automated backup configuration for a development environment. The objective of this task is to ensure a secure, well-monitored, and properly maintained system that follows operational and security best practices.

The activities were carried out to support two developers, Sarah and Mike, under the guidance of a Senior DevOps Engineer. The implementation includes monitoring tools, secure user account management, password policies, and automated backup mechanisms for Apache and Nginx web servers.

# 2. Task 1: System Monitoring Setup
   # Objective

    To configure monitoring tools that allow visibility into system performance, resource utilization, and capacity planning.

# Implementation Details

#  2.1 Monitoring Tools Installation
   # The following tools were used:
        htop / nmon – for CPU, memory, and process monitoring
        df          – to monitor disk usage
        du          – to identify directory-wise disk consumption  
  
# Installation (for Fedora-based systems):
    sudo dnf install epel-release -y
    sudo dnf install htop nmon -y

# 2.2 Resource Monitoring
    htop      - provides real-time CPU, memory, and process usage.
    nmon      - provides performance statistics and system load.
    df -h     - displays filesystem usage.
    du -sh *  - identifies space usage per directory.
    <img width="1349" height="714" alt="df commnd" src="https://github.com/user-attachments/assets/2025c317-c56d-4bfb-b63b-d8666d0acc35" />

# 2.3 Process Monitoring
    High resource–consuming processes can be identified using:
    
    htop or ps aux --sort=-%cpu | head

# 2.4 Logging System Metrics
   # System command outputs are redirected to log files for review:
        df -h >> /var/log/system_disk.log
        du -sh /var/* >> /var/log/system_usage.log
        These logs help in monitoring trends and capacity planning.

# 3. Task 2: User Management and Access Control
   # Objective

    To create secure user accounts for Sarah and Mike with restricted access, isolated directories, and enforced password policies.

# 3.1 User Creation
    sudo useradd -m -s /bin/bash sarah
    sudo useradd -m -s /bin/bash mike
    Each user receives a home directory and a default login shell.

# 3.2 Password Configuration
    sudo passwd sarah
    sudo passwd mike
    Strong passwords were set manually.

# 3.3 Workspace Directory Creation
    sudo mkdir -p /home/sarah/workspace
    sudo mkdir -p /home/mike/workspace

# 3.4 Ownership Assignment
    sudo chown -R sarah:sarah /home/sarah/workspace
    sudo chown -R mike:mike /home/mike/workspace

# 3.5 Permission Configuration
    sudo chmod 700 /home/sarah/workspace
    sudo chmod 700 /home/mike/workspace

# Result:
    Only the respective user can access their workspace.
    Other users are denied access.

# 3.6 Password Expiration Policy
    Password expiration was enforced using:
    sudo chage -M 30 sarah
    sudo chage -M 30 mike
   # To verify:
    sudo chage -l sarah
    sudo chage -l mike

# Passwords expire every 30 days.
# 3.7 Password Complexity Enforcement
    Edited configuration file:
    sudo nano /etc/security/pwquality.conf
    
   # Applied rules:
     minlen = 8 
     ucredit = -1
     lcredit = -1
     dcredit = -1
     ocredit = -1


   # These settings enforce:
     Minimum 8 characters
     At least one uppercase letter
     One lowercase letter
     One digit
     One special character
   # PAM configuration verified in:
     /etc/pam.d/system-auth

# 4. Task 3: Backup Configuration for Web Servers
# Objective
To configure automated backups for Apache and Nginx servers with verification and logging.

# 4.1 Backup Requirements
   # User       Server	    Configuration Path	    Document Root
    Sarah       Apache	    /etc/httpd	            /var/www/html
    Mike	    Nginx	    /etc/nginx	            /usr/share/nginx/html
# 4.2 Backup Directory
    sudo mkdir -p /backups
    sudo chmod 755 /backups

# 4.3 Apache Backup Script
   # File: /usr/local/bin/apache_backup.sh

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

# Make executable:
    sudo chmod +x /usr/local/bin/apache_backup.sh

# 4.4 Nginx Backup Script
   # File: /usr/local/bin/nginx_backup.sh

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

# Make executable:
    sudo chmod +x /usr/local/bin/nginx_backup.sh

# 4.5 Cron Job Configuration (Every Tuesday at 12:00 AM)
    Edit root cron:
    sudo crontab -e

    Add:
    0 0 * * 2 /usr/local/bin/apache_backup.sh
    0 0 * * 2 /usr/local/bin/nginx_backup.sh

# 4.6 Backup Verification
    Check files:
    ls -l /backups
    Verify archive content:
    tar -tzf /backups/apache_backup_YYYY-MM-DD_HH-MM-SS.tar.gz

# 5. Validation & Testing
   # Tests Performed:
     Verified user login for Sarah and Mike
     Confirmed access restriction between users
     Tested password expiration
     Verified cron execution
     Verified backup creation
     Verified archive integrity
     Checked log files

# 6. Challenges Faced and Resolution
   # Issue	                       Resolution
     htop not found	               Enabled EPEL repository
     tar: Cannot stat	           Corrected syntax and file paths
     Timezone access denied	       Used sudo privileges
     Backup warnings	           Adjusted tar usage
     Permission denied	           Fixed ownership and chmod

# 7. Conclusion
   # All required tasks were successfully implemented:
     * System monitoring tools were installed and configured
     * User accounts were securely created with proper permissions
     * Password expiration and complexity policies were enforced
     * Automated backups for Apache and Nginx were implemented
     * Cron scheduling and verification were completed
     * Logs were maintained for audit and troubleshooting

The system now meets operational, security, and maintenance standards expected in a production-like DevOps environment.

# Done by Santosh Kumar Sharma 
