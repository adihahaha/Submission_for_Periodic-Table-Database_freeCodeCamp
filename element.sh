#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit

else

  IN=$1
  if [[ $IN =~ ^[0-9]+$ ]]
  then
    IN_ATM_NUM=$($PSQL "SELECT * FROM elements WHERE atomic_number=$IN")
    ATM_NUM=$(echo $IN_ATM_NUM | cut -d '|' -f 1 | xargs)
    SYM=$(echo $IN_ATM_NUM | cut -d '|' -f 2 | xargs)
    ELE=$(echo $IN_ATM_NUM | cut -d '|' -f 3 | xargs)
    
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]
  then
    IN_SYM=$($PSQL "SELECT * FROM elements WHERE symbol='$IN'")
    
    if [[ -z $IN_SYM ]]
    then
      IN_NAME=$($PSQL "SELECT * FROM elements WHERE name='$IN'")
      ATM_NUM=$(echo $IN_NAME | cut -d '|' -f 1 | xargs)
      SYM=$(echo $IN_NAME | cut -d '|' -f 2 | xargs)
      ELE=$(echo $IN_NAME | cut -d '|' -f 3 | xargs)
    else
      ATM_NUM=$(echo $IN_SYM | cut -d '|' -f 1 | xargs)
      SYM=$(echo $IN_SYM | cut -d '|' -f 2 | xargs)
      ELE=$(echo $IN_SYM | cut -d '|' -f 3 | xargs)
    fi
  fi



  if [[ -z $IN_ATM_NUM ]] && [[ -z $IN_SYM ]] && [[ -z $IN_NAME ]]
  then

    echo "I could not find that element in the database."

  else

    PROP=$($PSQL "SELECT properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM properties JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $ATM_NUM")

    TYPE=$(echo $PROP | cut -d '|' -f 4 | xargs)
    BP=$(echo $PROP | cut -d '|' -f 3 | xargs)
    MP=$(echo $PROP | cut -d '|' -f 2 | xargs)
    MASS=$(echo $PROP | cut -d '|' -f 1 | xargs)

    echo "The element with atomic number $ATM_NUM is $ELE ($SYM). It's a $TYPE, with a mass of $MASS amu. $ELE has a melting point of $MP celsius and a boiling point of $BP celsius."
  fi
fi

