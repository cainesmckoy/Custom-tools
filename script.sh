#!/bin/sh
##### SCRIPT CREATED AND MAINTAINED BY #<Keshav Piplani> ######
#####FOR ANY QUERIES PLEASE CONTACT <keshavpiplani@gmail.com> ######

#Directory under which files backup needs to be taken
DIR="/data/jboss6/jboss-6.1.0.Final/server/default/log"
#backup location
backup="/data/jboss6/sonata_log_backup"
DAY=`date +%d`              
MONTH=`date +%m`           
YEAR=`date +%Y`           
MIN=`date +%M`
SEC=`date +%S`
date=`date +%F`

#Directory under which files backup needs to be taken

home="/data/jboss6/jboss-6.1.0.Final/server/default/log"
#script output folder
script="/data/jboss6/sonata_log_backup/dailyscript_output"
#1day old files
days=1
mkdir -p "$backup/dailyscript_output"
mkdir -p "$backup/dailyscript_output"/"$date"
mkdir -p  "$backup"/log/
mkdir -p  "$backup"/log/"$date"

mkdir -p "$backup/dailyscript_output" 2>>/$script/$date/error_log
mkdir -p "$backup/dailyscript_output"/"$date" 2>>/$script/$date/error_log
mkdir -p  "$backup"/log/ 2>>/$script/$date/error_log
mkdir -p  "$backup"/log/"$date" 2>>/$script/$date/error_log

files=($(find $DIR -maxdepth 1 -type f  -mtime +"$days" | grep -v gz | grep -i log )) 2>>/$script/find_error_log
echo "=================================================================="
echo "Zipping Files "
echo "Start  of script `date` "

echo "------------------------------------------------$date------------------------------------------------" >>"$script/$date"/In_use@"$DAY.$MONTH.$YEAR"notzipped.txt
echo "------------------------------------------------$date------------------------------------------------" >>"$script/$date"/zip_details_"$YEAR"_"$MONTH"_"$DAY".txt
echo "------------------------------------------------$date------------------------------------------------" >>"$script/$date"/onedayoldfiles_"$YEAR"_"$MONTH"_"$DAY".txt

for files in ${files[*]}
do


# Check whether files are in use (might still be being copied into directory)
/sbin/fuser "$files" > /dev/null 2>&1
fuser_output=`echo $?`


ls -l $files>>"$script/$date"/onedayoldfiles_"$YEAR"_"$MONTH"_"$DAY".txt
if [[ "$fuser_output" != "0" ]]; then


   #  echo $files
#zip files details in zip_details_date.txt
#ls -l $files>>"$script/$date"/zip_details_"$YEAR"_"$MONTH"_"$DAY".txt

 gzip "$files" 
 mv -i "$files".gz "$files"zipped@"$DAY.$MONTH.$YEAR".log.gz
ls -l "$files"zipped@"$DAY.$MONTH.$YEAR".log.gz | sed 's/\/log/\/log\/old_log_backup\/'$date'/g' >>"$script/$date"/zip_details_"$YEAR"_"$MONTH"_"$DAY".txt
 mv -i  "$files"zipped@"$DAY.$MONTH.$YEAR".log.gz "$home"/old_log_backup/"$date"/

else
         echo "$files is in use as on $date" >>"$script/$date"/In_use@"$DAY.$MONTH.$YEAR"notzipped.txt 
	echo " " >>$script/email"$date".txt

fi


done

all=`cat "$script/$date"/1dayoldfiles_"$YEAR"_"$MONTH"_"$DAY".txt | grep -v "$date" | wc -l `

Total=`cat "$script/$date"/zip_details_"$YEAR"_"$MONTH"_"$DAY".txt `
Totalno=`cat "$script/$date"/zip_details_"$YEAR"_"$MONTH"_"$DAY".txt |grep -v "$date-" | wc -l `
inuseno=`cat "$script/$date"/In_use@"$DAY.$MONTH.$YEAR"notzipped.txt | grep -v "$date-" | wc -l `
inuse=`cat "$script/$date"/In_use@"$DAY.$MONTH.$YEAR"notzipped.txt `
#echo $Total

echo "Start of Email " >>$script/email"$date".txt

echo " " >>$script/email"$date".txt
#echo " " >>$script/email.txt
echo "Zip file location:  $home/old_log_backup  at Box `hostname` " >>$script/email"$date".txt
echo " " >>$script/email"$date".txt
echo "Report Output stored in : $script  at Box `hostname`" >>$script/email"$date".txt
echo " " >>$script/email"$date".txt
echo  " "$all" files are  1day old,  See Below --- :">>$script/email"$date".txt

echo " `cat "$script/$date"/1dayoldfiles_"$YEAR"_"$MONTH"_"$DAY".txt ` " >>$script/email"$date".txt
echo " " >>$script/email"$date".txt

echo  "Total $Totalno Files got Zipped to $home/old_log_backup/$date , See Below ---" >>$script/email"$date".txt
echo   "$Total" >>$script/email"$date".txt
echo " " >>$script/email"$date".txt

echo  " $inuseno Files are in use are Below " >>$script/email"$date".txt
echo  " $inuse " >>$script/email"$date".txt
echo " " >>$script/email"$date".txt

echo "End of Email " >>$script/email"$date".txt
echo "SCRIPT CREATED BY  <keshavpiplani@gmail.com> " >>$script/email"$date".txt


cat $script/email"$date".txt | mailx -s "FILE Got zipped to 'old_log_backup' directory  on date $date for server `hostname` " "keshavpiplani@gmail.com"
>$script/email.txt

echo "End of script `date`"
echo "=================================================================="

