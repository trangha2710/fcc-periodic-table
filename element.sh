#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]; then
  echo "Please provide an element atomic number, symbol, or name as an argument."
  exit 0
fi
