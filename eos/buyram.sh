#!/bin/bash

TARGETPRICE=$1
echo $TARGETPRICE

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
      RAMJSON="$(sudo $CLEOSDIRBAK/cleos -u http://api.eosnewyork.io get table eosio eosio rammarket)"
    fi
  fi
fi 
# echo "RAM JSON:"
# echo "${RAMJSON}"

MOREROWS="$(echo "$RAMJSON" | jq -r '.more')"

if ! $MOREROWS ; then
  RAMROWS="$(echo "$RAMJSON" | jq -r '.rows[0]')"
  # echo "${RAMROWS}"
  RAMBASE="$(echo "$RAMROWS" | jq -r '.base.balance')"
  RAMQUOTE="$(echo "$RAMROWS" | jq -r '.quote.balance')"

  QUOTEVAL="$(echo $RAMQUOTE | sed 's/ EOS//')"
  BASEVAL="$(echo $RAMBASE | sed 's/ RAM//')"

  calc() { awk "BEGIN{print $*}"; }
  RAMPRICE=$(calc $QUOTEVAL*1024/$BASEVAL)
  echo "Current EOSRAM Price: $RAMPRICE EOS/KByte"
fi