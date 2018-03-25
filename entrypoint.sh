#!/bin/bash

trigger_shutdown() {
  echo Received shutdown signal, stopping RCE
  # this is the slower, but version-independent way:
  # /rce/rce -p /profile --shutdown  
  # this is the faster approach, using knowledge of the shutdown mechanism:
  PORT=$(cat /profile/internal/shutdown.dat | cut -f1 -d":")
  SECRET=$(cat /profile/internal/shutdown.dat | cut -f2 -d":")
  echo shutdown $SECRET > /dev/tcp/127.0.0.1/$PORT
  wait $(pidof rce)
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
