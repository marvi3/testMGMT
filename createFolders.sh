# This part is evaluating the given arguments

inputDir="../x_in_corpus_javascript"
nrTestRuns=1;
cpuCoresString="";
cpuCores=(0);
cpuCoresList=(0);

while getopts 'n:i:' opt; do
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
        i)
        if [ -z $OPTARG ]
        then
            echo "Please do not provide an empty location of the snippets.";
        else
            inputDir=$OPTARG;
            echo The script will use the snippets inside the direction $inputDir and copy them into the \"in\" folders.;
        fi
        ;;
    esac
done


# The next part reads in the folders and sub-folders

shopt -s nullglob
directories=(*/)


# The next part creates the folders for each instance

for dir in "${directories[@]}"
do
    curdir=$(pwd);
    # echo pwd is "$curdir"/"$inputDir/*";
    rm -r "$dir""00_vorlage/in";
    mkdir "$dir""00_vorlage/out";
    cp -r "$inputDir" "$dir""00_vorlage/in";
    # cd "$dir""00_vorlage/in";
    # ls;
    # cd ../../../;
    for ((run = 1; run <= $nrTestRuns; run++))
    do
        mv "$dir""$run" "$dir""$run""_old"
        cp -r "$dir""00_vorlage" "$dir""$run"
    done
done