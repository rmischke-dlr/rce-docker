#!/bin/bash

trigger_shutdown() {
  echo Received shutdown signal, stopping RCE
  /rce/rce --shutdown  
}
trap "trigger_shutdown" HUP INT QUIT TERM

echo Starting RCE
/rce/rce --headless $@ &
wait
echo Shutdown complete
