# testMGMT
Scripts for managing test runs on machines

## createFolders

### This script requires a certain folder structure.

An example of such a folder structure can be found with two sample fuzzers AFL and honggfuzz
 - The Script has to be executed inside of the first subfolder of the _runs_ folder which has the name of the SUT.
 - Inside this SUT folder each fuzzer has to have an own subfolder with a unique name.
 - Inside this fuzzer folder a folder with the name 00_vorlage has to exist.
 - Inside this 00_volage folder a file with the build and execution instructions called params.txt has to exist as well as all necessary binaries.
   - The sample file params.txt has more lines than required in order to run this script. The only required line is the one that starts with taskset.
     It is however advised to also store the extra information to make the evaluation easier.



### The required and optional parameters for the script:
 - **-i [directory to snipets]**
 - **-n [nr. of testruns]**

### The script then does the following:
 - It creates an input and output folder inside the 00_vorlage
 - It copies the input snipets inside the input folder
 - It copies the 00_vorlage folder and names it 1 2 3 etc.


## startTestruns

This script requires the same folder structure as createFolders.

 - The script has to be executed inside of the first subfolder of the _runs_ folder which hs the name of the SUT.
 - Inside this SUT folder each fuzzer has to have an own subfolder with a unique name.
 - Inside this fuzzer folder a folder with the name 1, 2, 3 ... n have to exist where n is the nr. of testruns.

### The required and optional parameters for the script:
 - **-n [nr. of testruns]** can not be larger than the number of folders created with the createFolders.sh script.
 - **-c [CPU-cores that should be used]** has to provide more cores than the -n times the fuzzers in the subfolder.
 - **-s [name of the SUT]** Is optional. If not used the -s parameter is set by the name of the containing folder.

### The script then does the following:
 - It opens a new screen session and starts all the windows with the respective commands.
 - It adjusts the params.txt by setting the right core for the _taskset -c_.
 - It adjusts the params.txt by setting the start time of the test-run.
 - It copies the command line that is needed to start the SUT
 - It starts the SUT
