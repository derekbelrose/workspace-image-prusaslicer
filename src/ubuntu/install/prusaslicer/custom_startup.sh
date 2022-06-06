#!/usr/bin/env bash

set -ex
START_COMMAND="PrusaSlicer.AppImage"


kasm_exec() {
  /usr/bin/filter_ready
  /usr/bin/desktop_ready

  $START_COMMAND
}

kasm_startup() {
  if [ -z "$DISABLE_CUSTOM_STARTUP" ] || [ -n "$FORCE" ]; then
    echo "Entering process startup loop"
    set +x
    while true
    do
      if ! pgreg -x $PGREP > /dev/null
      then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready

        set +e
        $START_COMMAND
        set -e 
      fi
      sleep 1
    done
    set -x
  fi
}

if [ -n "$GO" ] || [ -n "$ASSIGN ] ; then
  kasm_exec
else
  kasm_startup
fi
