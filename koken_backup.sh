#!/bin/bash
#
# adapted for koken sites by Marks
#
#
#
# fullsitebackup.sh V1.2
#
# Full backup of website files and database content.
#
# A number of variables defining file location and database connection
# information must be set before this script will run.
# Files are tar'ed from the root directory of the website. All files are
# saved. The MySQL database tables are dumped without a database name and
# and with the option to drop and recreate the tables.
#
#
# - Enjoy! BristolGuy
#-----------------------
#
## Parameters:
# tar_file_name (optional)
#
#
# Configuration
#

# Database connection information
dbname="koken_dbname" # (e.g.: dbname=kokendb)
dbhost="your.host"
dbuser="user" # (e.g.: dbuser=kokenuser)
dbpw="pswd" # (e.g.: dbuser password)

# Website Files
webrootdir="/home/user/koken.yourdomain.com" # (e.g.: webrootdir=/home/user/public_html)

#
# Variables
#

# Default TAR Output File Base Name
tarnamebase="kokensitebackup-"
datestamp=`date +'%m-%d-%Y'`

# Execution directory (script start point)
startdir=/home/user/backups
logfile=$startdir'/koken.log' # file path and name of log file to use

#####################################################################
############# END OF PARAMETERS  ####################################
#####################################################################

# Temporary Directory

tempdir=$datestamp
#
# Input Parameter Check
#

if test "$1" = ""
then
tarname=$tarnamebase$datestamp.tgz
else
tarname=$1
fi

#
# Begin logging
#
echo "Beginning koken site backup using koken_backup.sh ..." > $logfile
#
# Create temporary working directory
#
tempdirfull=${startdir}/${datestamp}
echo " Creating temp working dir $tempdirfull ..." >> $logfile
mkdir $tempdirfull
#
# TAR website files
#
echo " TARing website files into $webrootdir ..." >> $logfile
cd $webrootdir
tar cf $startdir/$tempdir/filecontent.tar .

#
# sqldump database information
#
echo " Dumping koken database, using ..." >> $logfile
echo " user:$dbuser; database:$dbname host:$dbhost " >> $logfile
cd $startdir/$tempdir
mysqldump --host=$dbhost --user=$dbuser --password=$dbpw --add-drop-table $dbname > dbcontent.sql

#
# Create final backup file
#
echo " Creating final compressed (tgz) TAR file: $tarname ..." >> $logfile
tar czf $startdir/$tarname filecontent.tar dbcontent.sql

#
# Cleanup
#
echo " Removing temp dir $tempdir ..." >> $logfile
cd $startdir
rm -r $tempdir

#
# Exit banner
#
endtime=`date`
echo "Backup completed $endtime, TAR file at $tarname. " >> $logfile