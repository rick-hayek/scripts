#!/bin/bash

CLEOSDIR="$HOME/eos/build/programs/cleos"
CLEOSDIRBAK="/usr/local/eosio/bin"

if ! type jq > /dev/null; then
  # install jq (for parsing json)
  echo "Installing tool jq ..."
  sudo apt install jq
fi


if [ -d $CLEOSDIR ]; then
  if [ -e $CLEOSDIR/cleos ]; then
    RAMJSON="$(sudo $CLEOSDIR/cleos -u http://api.eosnewyork.io get table eosio eosio rammarket)"
  fi

else
  if [ -d  $CLEOSDIRBAK ]; then
    if [ -e $CLEOSDIRBAK/cleos ]; then
      RAMJSON=sudo $CLEOSDIRBAK/cleos -u http://api.eosnewyork.io get table eosio eosio rammarket
    fi
  fi
fi 


echo "DONE"
echo "${RAMJSON}"

RAMROWS="$RAMJSON" | jq -r '.rows' 
echo "${RAMROWS}"
echo "$RAMROWS" | jq -r '.[0]'
