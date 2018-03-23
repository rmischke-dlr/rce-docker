#!/bin/bash

trigger_shutdown() {
  echo Received shutdown signal, stopping RCE
  /rce/rce -p /profile --shutdown  
}
trap "trigger_shutdown" HUP INT QUIT TERM

LAUNCH_TYPE="$1"
RCE_VERSION=$(cat /VERSION)
CONFIGURATION_FILE_LOCATION=/profile/configuration.json

case $LAUNCH_TYPE in
  relay)
    ln -s /presets/configuration-relay.json $CONFIGURATION_FILE_LOCATION
    LAUNCH_PARAMS=--disable-components
    ;;
  compute)
    ln -s /presets/configuration-compute-example.json $CONFIGURATION_FILE_LOCATION
    LAUNCH_PARAMS=
    ;;
  *)
    echo "Unrecognized or empty launch type parameter; current values are 'relay' and 'compute'"
    exit 1
esac

echo "Running RCE ($RCE_VERSION)"

/rce/rce --headless "$LAUNCH_PARAMS" -p /profile &
wait
echo Shutdown complete
