#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

# `-d64` option was removed in Java 10, this handles these versions accordingly
JAVA_FLAGS=""
if (( $(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1) < 10 )); then
    JAVA_FLAGS="-d64"
fi

DO_RAMDISK=0
if [[ $(cat server-setup-config.yaml | grep 'ramDisk:' | awk 'BEGIN {FS=":"}{print $2}') =~ "yes" ]]; then
    SAVE_DIR=$(cat server.properties | grep 'level-name' | awk 'BEGIN {FS="="}{print $2}')
    mv $SAVE_DIR "${SAVE_DIR}_backup"
    mkdir $SAVE_DIR
    sudo mount -t tmpfs -o size=2G tmpfs $SAVE_DIR
    DO_RAMDISK=1
fi

# check for serverstarter jar
if ! [[ -f serverstarter-0.3.18.jar ]]; then
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu serverstarter-*.jar server.properties server-setup-config.yaml
	# download missing serverstarter jar
	URL="https://github.com/BloodyMods/ServerStarter/releases/download/v2.2.0/serverstarter-2.2.0.jar"

	if command -v wget &> /dev/null; then
		echo "DEBUG: (wget) Downloading ${URL}"
		wget -O serverstarter-0.3.18.jar "${URL}"
	elif command -v curl &> /dev/null; then
		echo "DEBUG: (curl) Downloading ${URL}"
		curl -o serverstarter-0.3.18.jar "${URL}"
	else
		echo "Neither wget or curl were found on your system. Please install one and try again"
		exit 1
	fi
	mv /server.properties /data/server.properties
	mv /server-setup-config.yaml /data/server-setup-config.yaml
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


java $JAVA_FLAGS $JVM_OPTS -Dlog4j.configurationFile=log4j2_112-116.xml -jar serverstarter-0.3.18.jar
if [[ $DO_RAMDISK -eq 1 ]]; then
    sudo umount $SAVE_DIR
    rm -rf $SAVE_DIR
    mv "${SAVE_DIR}_backup" $SAVE_DIR
fi