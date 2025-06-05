#!/bin/bash

# PSQL command for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to display element information
display_element_info() {
  # Check if all expected variables are populated
  if [[ -z "$ATOMIC_NUMBER" || -z "$NAME" || -z "$SYMBOL" || -z "$TYPE" || -z "$ATOMIC_MASS" || -z "$MELTING_POINT" || -z "$BOILING_POINT" ]]; then
    echo "Error: Incomplete data retrieved for the element."
    exit 1
  fi
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

# --- Main Script Logic ---

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1
QUERY_COMMAND=""

# Define the common SELECT clause, formatting atomic_mass using TO_CHAR
# 'FM9999999999999999990.999999999999999999' is a format string.
# FM (Fill Mode) removes leading/trailing spaces and leading zeros.
# The string of '9's and '0' allows for varying precision and scale while ensuring
# non-zero decimal parts are kept, and trailing zeros are removed.
SELECT_CLAUSE="e.atomic_number, e.name, e.symbol, t.type, TRIM(TO_CHAR(p.atomic_mass, 'FM9999999999999999990.999999999999999999')) AS atomic_mass, p.melting_point_celsius, p.boiling_point_celsius"
FROM_CLAUSE="FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id"


# Determine the query based on input type
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  QUERY_COMMAND="SELECT $SELECT_CLAUSE $FROM_CLAUSE WHERE e.atomic_number = $INPUT"
elif [[ ${#INPUT} -le 2 ]]
then
  QUERY_COMMAND="SELECT $SELECT_CLAUSE $FROM_CLAUSE WHERE e.symbol = INITCAP('$INPUT')"
else
  QUERY_COMMAND="SELECT $SELECT_CLAUSE $FROM_CLAUSE WHERE e.name = INITCAP('$INPUT')"
fi

# Execute the PSQL query
QUERY_RESULT=$($PSQL "$QUERY_COMMAND")

# Check PSQL command exit status for database connection/query errors
if [[ $? -ne 0 ]]; then
  echo "Error: Could not connect to the database or execute query. Please check database status and PSQL command."
  exit 1
fi

# Check if an element was found
if [[ -z $QUERY_RESULT ]]
then
  echo "I could not find that element in the database."
else
  # Parse the query result
  IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$QUERY_RESULT"
  display_element_info # Call the function to display and validate variables
fi
