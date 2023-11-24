
# This part is evaluating the given arguments
logFileName='logCPUTemp.txt';
timeInterval='1';
while getopts 'n:i:' opt; do
  case "$opt" in
    n)
      if [ -z $OPTARG ]
      then
        echo "Please do not provide an empty name for the logFile.";
      else
        logFileName=$OPTARG;
        echo The results of the temperature and frequency measurement will be written to $logFileName.;
      fi
      ;;
    i)
      if [ -z $OPTARG ]
      then
        echo "Please do not provide an empty name number for the interval time.";
      else
        timeInterval=$OPTARG;
        echo The temperature and CPU frequency will be measured every $timeInterval seconds.;
      fi
      ;;
  esac
done



# Here the measurement starts
date >> $logFileName;
sensors >> $logFileName;
sleep $timeInterval;

while true;
do
  echo "__________"$'\n'$'\n' >> $logFileName;
  date >> $logFileName;
  sensors >> $logFileName;
  sleep $timeInterval;
done
