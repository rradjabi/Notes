#!/bin/sh
# Notes version 0.5
DIR=~/Notes/
PREFIX=$1
DATE=`date +%Y-%m-%d`
#echo $DATE
EDIT=1
LIST_DIRS=0
ALL=0
MERGE=0
MERGE_DIR_PRE=.merge_
COOKIE_FILE=DNE


if [ "$1" == "help" ]; then
    echo Notes program created by Ryan Radjabi
    echo    Usage:
    echo        "Edit today's notes:                        'notes'"
    echo        "Print today's notes:                       'notes p'"
    echo        "Print all Daily notes:                     'notes p a'"
    echo        "Edit yesterday's notes:                    'notes 1 e'"
    echo        "Print yesterday's notes:                   'notes 1'"
    echo        "Edit today's <meeting name> notes:         'notes <meeting name>'"
    echo        "Print today's <meeting name> notes:        'notes <meeting name> p'"
    echo        "Print all <meeting name> notes:            'notes <meeting name> p a'"
    echo        "Print yesterday's <meeting name> notes:    'notes <meeting name> 1'"
    echo        "List all notes:                            'notes ls'"
    echo        "Merge daily notes into single file:        'notes <meeting name> m'"
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
        if [ $# == 2 ]; then
            if [ $2 == "a" ]; then
                ALL=1;
            fi
        fi
    else
        PREFIX=$1
        if [ $# == 2 ]; then # second argument exists
            if [ $2 == "m" ]; then # merge all with prefix
                MERGE=1
                EDIT=1
            elif [ $2 > 0 ]; then
                DATE=`date -d "$DATE - $2 day" +%Y-%m-%d` # prints current date - x days
                echo $PREFIX
                EDIT=0
            fi # numeric
        else
            EDIT=1
            if [ $# == 3 ]; then
                if [ $2 == "p" ]; then
                    EDIT=0;
                    if [ $3 == "a" ]; then
                        ALL=1; # example: notes Convergence p a >> print all notes of Convergence type
                    fi                        
                fi 
            fi
        fi # more than 1 arg
    fi

    FILE=$DIR$PREFIX-$DATE
    echo $FILE
            
    if [ $1 = "ls" ]; then
        EDIT=0
        LIST_DIRS=1
    fi

fi # check on numeric/alpha argument 


# check for existince of backup / merge dir
# if exists, then remove date from filename, then proceed.
if [ -d "$DIR$MERGE_DIR_PRE$PREFIX" ]; then
    COOKIE_FILE="$DIR$MERGE_DIR_PRE$PREFIX/$PREFIX-$DATE"
    FILE=$DIR$PREFIX
    MERGE=1
else
    if [ $MERGE == 1 ]; then
       # COOKIE_FILE=$DIR$MERGE_DIR_PRE$PREFIX-$DATE
        COOKIE_FILE="$DIR$MERGE_DIR_PRE$PREFIX/$PREFIX-$DATE"
        FILE=$DIR$PREFIX
        # merge all files with PREFIX
        TMP_PRE=DO_NOT_MOVE_
        cat $DIR$PREFIX* > $DIR$TMP_PRE$PREFIX
        mkdir $DIR$MERGE_DIR_PRE$PREFIX
        mv $DIR$PREFIX* $DIR$MERGE_DIR_PRE$PREFIX
        mv $DIR$TMP_PRE$PREFIX $FILE
    fi
fi


if [ $EDIT == 1 ]; then

    if [ $MERGE == 1 ]; then
        if [ ! -f "$COOKIE_FILE" ]; then
            touch $COOKIE_FILE
            echo "== $PREFIX notes for $DATE ==" >> $FILE 
        fi
    fi
    vim $FILE
    ls $DIR
else
    if [ $LIST_DIRS != 1 ]; then
        echo 
        echo
        echo ~~~~~~~~~~~~~~~~~~
        if [ $ALL == 0 ]; then
            cat -n $FILE
        else
            cat -n $DIR$PREFIX*
        fi
    else
        ls -1 $DIR
    fi
fi


