#!/usr/bin/bash
#This script will automate the back ups of specified folders and files of a user's home directory
#It is the preperation before being sent to a remote server by the server team
######################################################################
#Declaring variables
getDate=$(date +%Y-%m-%d)  #Grabs the date into a variable
getLastDate=$(date -d "last friday" +%Y-%m-%d) #grabs the date of last
previousLogFile=backups_$getLastDate.log
######################################################################

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
'''
TO BE REVIEWED BY ANTONIO PRADA!!!!!

if [ cat /var/backup_logs/$previousLogFile | grep success ]
then
  zenity --info --width=300 --text="Your files have been successfully backed up!"
else
  zenity --info --width=300 --text="Your backup has failed, please submit a ticket to determine the failure."
fi
'''
######################################################################
#Parsing and copying folders and files to back up folder
getDate=$(date +%Y-%m-%d) 
mkdir ~/backupFolder$getDate   #to creat the backup folder with dates.
backupFolder=~/backupFolder$getDate 

cp -R ~/Music $backupFolder #to copy the music directory into the backup directory
cp -R ~/Documents $backupFolder  #copy documents into teh backup folder
cp -R ~/Pictures $backupFolder  #copy pictures to bakup
cp -R ~/Public $backupFolder  #copy public to bakup
cp -R ~/Templates $backupFolder #copy templates to backup
cp -R ~/.bash_history $backupFolder #copy bashhistory to backup
cp -R ~/.bash_profile $backupFolder

tar -czvf $backupFolder.tar.gz $backupFolder/ 
######################################################################
######################################################################
#Logging Portion
#Variable storing the log file name
logFileName=backups_$getDate.log #name of the log file

#The following conditional tests for a log directory, if not present
#It will be created and log file created as well.
if [ ! -d ~/.local/log ]
then
  mkdir ~/.local/log/
  mkdir ~/.local/log/backup_logs
  touch ~/.local/log/backup_logs/$logFileName
else
  touch ~/.local/log/backup_logs/$logFileName
fi

#The following conditional tests if the backup folder is empty
#If its empty, then a log file will be appeneded with failed otherwise successful
if [ ! "$(ls -A $backupFolder)" ]
then
    echo "backup failed" >> ~/.local/log/backup_logs/$logFileName
else
  ls -A -R $backupFolder  > ~/.local/log/backup_logs/$logFileName
  echo "backup successful" >> ~/.local/log/backup_logs/$logFileName
fi
######################################################################
######################################################################
#Remove the original backup folder after archiving
rm -r $backupFolder
######################################################################
