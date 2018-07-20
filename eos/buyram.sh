#!/bin/bash
CLEOSDIR="$HOME/eos/build/programs/cleos"
CLEOSDIRBAK="/usr/local/eosio/bin"

if ! type jq > /dev/null; then
  # install jq (for parsing json)
  echo "Installing tool jq ..."
  sudo apt install jq
fi

numCompare() {
   #awk -v n1="$1" -v n2="$2" 'BEGIN {printf "%s " (n1<n2?"<":n1>n2?">":"=") " %s\n", n1, n2}'
   numCompareResult="$(awk -v n1="$1" -v n2="$2" 'BEGIN {printf (n1<n2?"-1":n1>n2?"1":"0")}')"
   echo $numCompareResult
}

getRamRealtimePrice(){

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

    echo "Current EOSRAM Price: $RAMPRICE EOS/KByte" >&2

    echo $RAMPRICE
  fi

  return 0
}


REALTIMEPRICE="$(getRamRealtimePrice)"

TARGETPRICE=$1
echo "Expected EOSRAM Price: $TARGETPRICE EOS/KByte"

SELLIT="$(numCompare $REALTIMEPRICE $TARGETPRICE)"
#echo $SELLIT
if [ ${SELLIT} -gt 0 ] ; then
  echo "SELL IT!!!"
  
  # Sell RAM
else
  echo "Behind the expectation. Let's keep the RAM for now."
fi