# testMGMT
Scripts for managing test runs on machines

## createFolders

### This script requires a certain folder structure.

 - It has to be executed inside of the first subfolder of the _runs_ folder which hs the name of the SUT.
 - Inside this SUT folder each fuzzer has to have an own subfolder with a unique name.
 - Inside this fuzzer folder a folder with the name 00_vorlage has to exist.
 - Inside this 00_volage folder a file with the build and execution instructions called param.txt has to exist as well as all necessary binaries.

### An example of the param.txt looks like the following:

### The required and optional parameters for the script:
 - **-i [directory to snipets]**
 - **-n [nr. of testruns]**

### The script then does the following:
 - It creates an input and output folder inside the 00_vorlage
 - It copies the input snipets inside the input folder
 - It copies the 00_vorlage folder and names it 1 2 3 etc.


## startTestruns

### This script requires a certain folder structure.

 - It has to be executed inside of the first subfolder of the _runs_ folder which hs the name of the SUT.
 - Inside this SUT folder each fuzzer has to have an own subfolder with a unique name.
 - Inside this fuzzer folder a folder with the name 1, 2, 3 ... n have to exist where n is the nr. of testruns.

### An example of the param.txt looks like the following:

### The required and optional parameters for the script:
 - **-n [nr. of testruns]**
 - **-c [CPU-cores that should be used]**
 - **-s [name of the SUT]**

### The script then does the following:
 - It opens a new screen session and starts all the windows with the respective commands.
 - It adjusts the param.txt by setting the right core for the _taskset -c_.
 - It adjusts the param.txt by setting the start time of the test-run.
