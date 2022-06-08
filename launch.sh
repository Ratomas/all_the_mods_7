#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f server-0.4.9.sh ]]; then
	rm -fr config defaultconfigs kubejs libraries mods packmenu server-*.sh server.properties
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

curl -o log4j2_112-116.xml https://launcher.mojang.com/v1/objects/02937d122c86ce73319ef9975b58896fc1b491d1/log4j2_112-116.xml

# Forge requires a configured set of both JVM and program arguments.
# Add custom JVM arguments to the user_jvm_args.txt
# Add custom program arguments {such as nogui} to this file in the next line before the "$@" or
#  pass them to this script directly
java $JAVA_FLAGS $JVM_OPTS -Dlog4j.configurationFile=log4j2_112-116.xml @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.18.2-40.1.31/unix_args.txt "$@"

