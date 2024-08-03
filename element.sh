#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

IN=$1
if [[ $IN =~ ^[0-9]+$ ]]
then
  IN_ATM_NUM=$($PSQL "SELECT * FROM elements WHERE atomic_number=$IN")
  ATM_NUM=$(echo $IN_ATM_NUM | cut -d '|' -f 1 | xargs)
  SYM=$(echo $IN_ATM_NUM | cut -d '|' -f 2 | xargs)
  ELE=$(echo $IN_ATM_NUM | cut -d '|' -f 3 | xargs)
  
elif [[ $1 =~ ^[a-zA-Z]=$ ]]
then
  IN_ATM_NUM=$($PSQL "SELECT * FROM elements WHERE symbol='$IN'")
  ATM_NUM=$(echo $IN_ATM_NUM | cut -d '|' -f 1 | xargs)
  SYM=$(echo $IN_ATM_NUM | cut -d '|' -f 2 | xargs)
  ELE=$(echo $IN_ATM_NUM | cut -d '|' -f 3 | xargs)
  
  if [[ -n $IN_ATM_NUM ]]
  then
    echo Failed
  fi
fi

echo "The element with atomic number $ATM_NUM is $ELE ($SYM)."