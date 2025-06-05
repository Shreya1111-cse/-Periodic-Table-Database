#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1

# Check if input is an atomic number
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $INPUT")
elif [[ ${#INPUT} -le 2 ]] # Check if input is a symbol (1 or 2 characters)
then
  QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.symbol = INITCAP('$INPUT')")
else # Assume input is a name
  QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.name = INITCAP('$INPUT')")
fi

if [[ -z $QUERY_RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$QUERY_RESULT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
