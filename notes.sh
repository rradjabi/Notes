#!/bin/sh
DIR=~/Notes/
PREFIX=$1
DATE=`date +%Y-%m-%d`
#echo $DATE
EDIT=1
LIST_DIRS=0


if [ "$1" == "help" ]; then
    echo Notes program created by Ryan Radjabi
    echo    Usage:
    echo        "Edit today's notes:                        'notes'"
    echo        "Print today's notes:                       'notes p'"
    echo        "Edit yesterday's notes:                    'notes 1 e'"
    echo        "Print yesterday's notes:                   'notes 1'"
    echo        "Edit today's <meeting name> notes:         'notes <meeting name>"
    echo        "Print today's <meeting name> notes:        'notes <meeting name> p"
    echo        "Print yesterday's <meeting name> notes:    'notes <meeting name> 1"
    echo        "List all notes:                            'notes ls'"
    exit
fi

# Check that input is only numeric
if [ -z `echo $1 | tr -d "[:digit:]"` ]; then
#    echo "Input contains only numeric characters"
    if [ $1 > 0 ]; then
        DATE=`date -d "$DATE - $1 day" +%Y-%m-%d` # prints current date - x days
        if [ $# == 2 ]; then
            if [ $2 == "e" ]; then
#                echo performing edit
                EDIT=1
            else
#                echo listing notes
                EDIT=0
            fi # Check argument is 'e' for edit
        else
#            echo argment length is too short for edit
            EDIT=0
        fi # check argument length equals 2
    fi # check if first argument is greater than 0
    PREFIX=Daily
    FILE=$DIR$PREFIX-$DATE
else # input is alpha
    if [ $1 == "p" ]; then # p for print
        EDIT=0 
        PREFIX=Daily
    else
        PREFIX=$1
        if [ $# == 2 ]; then
            if [ $2 > 0 ]; then
                DATE=`date -d "$DATE - $2 day" +%Y-%m-%d` # prints current date - x days
                echo $DATE
                echo $PREFIX
            fi # numeric
            EDIT=0
        else
            EDIT=1
        fi # more than 1 arg
    fi

#    echo prefix: $PREFIX
    FILE=$DIR$PREFIX-$DATE
    echo $FILE
            
    if [ $1 = "ls" ]; then
        EDIT=0
        LIST_DIRS=1
    fi

fi # check on numeric/alpha argument 

if [ $EDIT == 1 ]; then
    if [ ! -f $FILE ]; then
        touch $FILE
        echo "== $PREFIX notes for $DATE ==" > $FILE 
    fi
    vim $FILE
    ls $DIR
else
    if [ $LIST_DIRS != 1 ]; then
        echo 
        echo
        echo ~~~~~~~~~~~~~~~~~~
        cat $FILE
    else
        ls -1 $DIR
    fi
fi

