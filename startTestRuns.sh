# This part is evaluating the given arguments
sutName=${PWD##*/}
nrTestRuns=1;
cpuCoresString="";
cpuCores=(0);
cpuCoresList=(0);
cpuCoresUsedList=();
curExecution=0;

while getopts 'n:s:c:' opt; do
    case "$opt" in
        n)
        if [ -z $OPTARG ]
        then
            echo "Please do not provide an empty number of testruns.";
        else
            nrTestRuns=$OPTARG;
            echo The script will generate folders for $nrTestRuns test runs for each SUT.;
        fi
        ;;
        c)
        if [ -z $OPTARG ]
        then
            echo "Please do not provide an empty list of processors.";
        else
            cpuCoresString=$OPTARG;
            unset cpuCores[0];
            IFS=',' read -ra cpuCores <<< $cpuCoresString;
            unset cpuCoresList[0];
            for i in "${cpuCores[@]}"; do
                if [[ "$i" == *"-"* ]]
                then
                    range=();
                    IFS='-' read -ra range <<< $i;
                    for ((j = ${range[0]}; j <= ${range[1]}; j++))
                    do
                        cpuCoresList+=($j);
                    done
                else
                    cpuCoresList+=($i);
                fi
            done
            echo The script will run on the cores "${cpuCoresList[*]}".;
        fi
        ;;
        s)
        if [ -z $OPTARG ]
        then
            echo "Please do not provide an empty name of the SUT.";
        else
            inputDir=$OPTARG;
            echo The script will use the $scriptName as a name for the screen session.;
        fi
        ;;
    esac
done


# The next part reads in the folders
shopt -s nullglob;
directories=(*/);
echo ${directories[@]};

# This part checks whether enough cores for the number of runs are provided
if [[ $((${#directories[@]} * $nrTestRuns)) -gt $(( ${#cpuCoresList[@]} )) ]]
then
    echo You want to run $((${#directories[@]} * $nrTestRuns)) testruns but have only provided a list of ${#cpuCoresList[@]} available cpu cores with the -c option.;
    echo Please add more available cpu cores.;
    exit 1; 
fi 

# The next part:
# - creates the screen windows
# - changes the param.txt file at the CPU used and adds the starting time
# - copies the command line to start the SUT
# - starts the SUT

for dir in "${directories[@]}"
do
    for ((run = 1; run <= $nrTestRuns; run++))
    do
        if ! screen -list | grep -q "$sutName"; then
            cd "$dir""$run";
            # sed -i -e "s/\taskset\ -c\ [[:digit:]]*/${cpuCoresList[0]}/" .params.txt;
            sed -i -e "s/taskset\ -c\ [[:digit:]]*/taskset\ -c\ ${cpuCoresList[$curExecution]}/" params.txt;
            datum=$(date +"%d.%m.%Y %H:%M");
            sed -i -e "s/started:.*/started:\ $datum/" "/params.txt";
            runCommand="";
            while read line
            do
                if [[ $line = *taskset* ]]
                then
                    runCommand=$line;
                fi
            done < "params.txt"
            echo The script of "$dir""$run" will run on the core "${cpuCoresList[$curExecution]}" and execute $runCommand.;
            curExecution=$((curExecution + 1));
            screen -S "$sutName" -d -m;
            screen -S "$sutName" -X exec $runCommand;
            cd ../../;
        else
            sed -i -e "s/taskset\ -c\ [[:digit:]]*/taskset\ -c\ ${cpuCoresList[$curExecution]}/" "$dir""$run""/params.txt";
            datum=$(date +"%d.%m.%Y %H:%M");
            sed -i -e "s/started:.*/started:\ $datum/" "$dir""$run""/params.txt";
            runCommand="";
            while read line
            do
                if [[ $line = *taskset* ]]
                then
                    runCommand=$line;
                fi
            done < "$dir""$run""/params.txt"
            echo The script of "$dir""$run" will run on the core "${cpuCoresList[$curExecution]}" and execute $runCommand.;
            curExecution=$((curExecution + 1));
            screen -S "$sutName" -X chdir "../../""$dir""$run";
            screen -S "$sutName" -X screen;
            # screen -S "$sutName" -X exec pwd;cd h
            screen -S "$sutName" -X exec $runCommand;
        fi
    done
done
