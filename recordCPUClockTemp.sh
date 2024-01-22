
# This part is evaluating the given arguments
logFileName='logCPUTemp.txt';
intervalTime='1';
totalTime=0;
totalSeconds=0;
totalMinutes=0;
totalHours=0;
totalDays=0;
totalIntervals=-1;
while getopts 'n:i:t:' opt; do
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
        echo "Please do not provide an empty number for the interval time.";
      else
        intervalTime=$OPTARG;
        echo The temperature and CPU frequency will be measured every $intervalTime seconds.;
      fi
      ;;
    t)
      if [ -z $OPTARG ]
      then
        echo "Please do not provide an empty number for the total time.";
      else
        totalTime=$OPTARG;
        totalSeconds=$totalTime
        if [ $totalSeconds -gt 59 ];then
	  echo Seconds;
          totalMinutes=$(($totalSeconds / 60));
	  totalSeconds=$(($totalSeconds % 60));
	fi
	if [ $totalMinutes -gt 59 ];then
	  totalHours=$(($totalMinutes / 60));
	  totalMinutes=$(($totalMinutes % 60));
	fi
	if [ $totalHours -gt 23 ];then
	  totalDays=$(($totalHours / 24));
	  totalHours=$(($totalHours % 24));
	fi
	echo The temperature and CPU frequency will be measured every $intervalTime seconds for $totalTime seconds.;
	echo This are $totalDays days, $totalHours hours, $totalMinutes minutes and $totalSeconds seconds.;
      fi
      ;;
  esac
done

if [ $totalTime -ne 0 ]; then
  totalIntervals=$(($totalTime / $intervalTime - 1))
  echo During that time a total of $(($totalIntervals + 1)) measurings will be recorded.;
fi

# Here the measurement starts
date >> $logFileName;
sensors >> $logFileName;
mpstat -P ALL $intervalTime 1 | tail -n 66 >> $logFileName;

while [ $totalIntervals -ne 0 ];
do
  echo "__________"$'\n'$'\n' >> $logFileName;
  date >> $logFileName;
  sensors >> $logFileName;
  mpstat -P ALL $intervalTime 1 | tail -n 66 >> $logFileName;
  ((totalIntervals=totalIntervals-1));
done
