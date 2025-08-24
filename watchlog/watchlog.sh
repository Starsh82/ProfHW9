#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
logger "$DATE: Слово ALERT найдено! Starsh!"
else
exit 0
fi
