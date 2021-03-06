#!/bin/bash

# Launch, utilizing the SIGTERM/SIGINT propagation pattern from
# http://veithen.github.io/2014/11/16/sigterm-propagation.html
: ${PARAMS:=""}
trap 'kill -TERM $PID' TERM INT

PATH='/root/.unobtanium/blocks/blk00000.dat'

# Check if testnet or not
if [[ "$PARAMS" == *"testnet"* ]]; then
    PATH='/root/.unobtanium/testnet3/blocks/blk00000.dat'
fi

if [ ! -f ${PATH} ]; then
    /usr/local/bin/unobtaniumd -reindex ${PARAMS} $@ &
else
    /usr/local/bin/unobtaniumd ${PARAMS} $@ &
fi
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?
