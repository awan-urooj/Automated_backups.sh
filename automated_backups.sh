#!/usr/bin/env bash

# This script will automate the back ups of specified folders and files of a user's home directory
# It is the preperation before being sent to a remote server by the server team


#Important variable names
getDate=$(date +%Y-%m-%d)  #Grabs the date into a variable
logFileName=backups_$getDate.log #name of the log file
getLastDate=$(date -d "last friday" +%Y-%m-%d)
previousLogFile=backups_$getLastDate.log
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

mkdir ~/backup_$getDate   #to creat the backup folder with dates.
backupFolder = ~/backup_$getDate #Stores the backup folder in a variable

cp -R ~/Music $backupFolder #to copy the music directory into the backup directory
cp -R ~/Documents $backupFolder  #copy documents into teh backup folder
cp -R ~/Pictures $backupFolder  #copy pictures to bakup
cp -R ~/Public $backupFolder  #copy public to bakup
cp -R ~/Templates $backupFolder #copy templates to backup
cp -R ~/.bash_history $backupFolder #copy bashhistory to backup
cp -R ~/.bash_profile $backupFolder

tar -cvf $backupFolder $backupFolder.tar.gz


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


###########################################################################
#this session will create the bakup folder and copy the other directories into the backup folder


mkdir ~/backup_$getDate

#This next line grabs the contents of the backup directory and appends it to a
#log file.
if [ ! "$(ls -A $backupFolder)" ]
then
    echo "backup failed" > /var/log/backup_logs/$logFileName
else
  ls -A -R %backupFolder  > /var/log/backup_logs/$logFileName
  echo "backup successful" >> /var/log/backup_logs/$logFileName
fi

#The next line deletes the backup folder NOT the tar.gz file
#That has to be created from this folder

rm -r $backupFolder

#
#
#
#
