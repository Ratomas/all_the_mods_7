#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f server-0.4.34.sh ]]; then
	rm -fr config defaultconfigs kubejs mods server-*.sh server.properties
	mv /server/* /data/
	rm -rf /server	

fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" server.properties
fi
if [[ -n "$LEVELTYPE" ]]; then
    sed -i "/level-type\s*=/ c level-type=$LEVELTYPE" server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

./server-0.4.34.sh

