#!/bin/bash

# merge import volume content with hub test config
cp -a "$IMPORT_VOLUME/"* ./hub/
cp -a "$IMPORT_VOLUME/".* ./hub/

# copy results with parent dir to the export volume path
function result_collector {
  cd hub/.tests || return
  find . -type d -name results -not -empty -exec cp --parents -r {} "$EXPORT_VOLUME"/ \;
  echo "Test results copied to $EXPORT_VOLUME volume"
  [ -n "$CONTAINER_LINGER" ] && read -rp "Press any key to exit"
}
trap result_collector EXIT

if [ -n "$1" ]; then
    "$@"
else
  for dir in "$IMPORT_VOLUME/".tests/*; do
    if [ -d "$dir" ]; then
      dirname=$(basename "$dir")
      # TODO: check other available testing commands
      ./cscli hubtest --config ./dev.yaml \
        --hub ./hub --cscli "$PWD/cscli" --crowdsec "$PWD/crowdsec" \
        run --clean --debug "$dirname"
    fi
  done
fi
