#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi
INPUT_VALUE="$1"
if [[ $INPUT_VALUE =~ ^[0-9]+$ ]]; then
  WHERE_CLAUSE="WHERE e.atomic_number = $INPUT_VALUE"
else
  # Input is text (symbol or name)
  WHERE_CLAUSE="WHERE e.symbol = '$INPUT_VALUE' OR e.name = '$INPUT_VALUE'"
fi
ELEMENT_DATA=$($PSQL "
  SELECT 
    e.atomic_number, 
    e.name, 
    e.symbol, 
    p.atomic_mass, 
    p.melting_point_celsius, 
    p.boiling_point_celsius, 
    t.type
  FROM 
    elements e
    JOIN properties p ON e.atomic_number = p.atomic_number
    JOIN types t ON p.type_id = t.type_id
  $WHERE_CLAUSE
")

# Trim whitespace from the result and use IFS (Internal Field Separator) to parse the single line into variables
TRIMMED_DATA=$(echo "$ELEMENT_DATA" | xargs)

if [[ -z "$TRIMMED_DATA" ]]; then
  echo "I could not find that element in the database."
else
  # Set IFS to the pipe character (default psql separator with --no-align) to split the row into variables
  IFS='|' read -r ATOMIC_NUM NAME SYMBOL MASS MP BP TYPE <<< "$TRIMMED_DATA"

  # Print the formatted message exactly as requested
  echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
fi