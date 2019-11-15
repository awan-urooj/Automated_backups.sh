#!/usr/bin/env bash

# This script will automate the back ups of specified folders and files of a user's home directory
# It is the preperation before being sent to a remote server by the server team


#Important variable names
getDate=$(date +%Y-%m-%d)  #Grabs the date into a variable
logFileName=backups_$getDate.log #name of the log file
getYesterdaysDate=$(date -d "yesterday" +%Y-%m-%d)
previousLogFile=backups_$getYesterdaysDate.log
################################################################

#This portion if for the zenity prompt
#This will be a separate script to check if the backup directory
#exists when the users logs in to confirm successful backup
#This script will exist in the bash profile and will prompt the user at logon
if [ -d /var/log/backup_logs ]
then
  zenity --info --width=300 --text="Your files have been successfully backed up!"
else
  zenity --info --width=300 --text="Your backup has failed, please submit a ticket to determine the failure."
fi
#
#
#


'''
TO BE REVIEWED BY ANTONIO PRADA!!!!!

if [ cat /var/backup_logs/$previousLogFile | grep success ]
then
  zenity --info --width=300 --text="Your files have been successfully backed up!"
else
  zenity --info --width=300 --text="Your backup has failed, please submit a ticket to determine the failure."
fi
'''

################################################################

#This portion is for the the archiving and parsing
#
#
#
#
#


################################################################
#This portion is for the logging
# If statemnet to create log directory for all logs going forward
# Directory is created if not found | If found just create log file
if [ ! -d /var/log/backup_logs ]
then
  mkdir /var/log/backup_logs
  touch /var/log/backup_logs/$logFileName
else
  touch /var/log/backup_logs/$logFileName
fi

#Urooj please provide back up directory name or var for the following line
#This next line grabs the contents of the backup directory and appends it to a
#log file.
if [ ! "$(ls -A $PATH_OR_VAR)" ]
then
    echo "backup failed" >> /var/log/backup_logs/$logFileName
else
  ls -A -R $INSERT_PATH_OR_VARIABLE_FOR_DIRECTORY_CREATED_FOR_BACKUPS  > /var/log/backup_logs/$logFileName
  echo "backup successful" >> /var/log/backup_logs/$logFileName
fi

#The next line deletes the backup folder NOT the tar.gz file
#That has to be created from this folder
rm -r $INSERT_PATH_OR_VARIABLE_FOR_DIRECTORY_CREATED_FOR_BACKUPS

mkdir `date +%m%d%Y`_backup   #this little peace takes me 4 hours

#
#
#
#
