#!/bin/bash

################################################################################
# Executes command with a timeout
# Params:
#   $1 timeout in seconds
#   $2 command
# Returns 1 if timed out 0 otherwise
timeout() {

    time=$1

    # start the command in a subshell to avoid problem with pipes
    # (spawn accepts one command)
    command="/bin/sh -c \"$2\""

    expect -c "set echo \"-noecho\"; set timeout $time; spawn -noecho $command; expect timeout { exit 1 } eof { exit 0 }"    

    if [ $? = 1 ] ; then
        echo "Timeout after ${time} seconds"
    fi

}

test_cases_file="pmlb_cegar.txt"
program="python3 experiment-qbf.py -bench pmlb_tmp.txt $1 $2"
cat $test_cases_file | while read oneline
do
    echo "$oneline" > pmlb_tmp.txt
    timeout 18000 "$program"
done

exit 0
