# [All the Mods 7](https://www.curseforge.com/minecraft/modpacks/all-the-mods-7)
<!-- MarkdownTOC autolink="true" indent="  " markdown_preview="github" -->

- [Description](#description)
- [Requirements](#requirements)
- [Options](#options)
- [Adding Minecraft Operators](#adding-minecraft-operators)
- [Source](#source)

<!-- /MarkdownTOC -->

## Description


Docker Container for All the Mods 7 Minecraft Modpack

The docker on first run will download the same version as tagged of All the Mods 7 and install it.  This can take a while as the Forge installer can take a bit to complete.  You can watch the logs and it will eventually finish.

After the first run it will simply start the server.

## Requirements

* /data mounted to a persistent disk
* Make sure that the EULA  is set to `true`

## Options

These environment variables can be set at run time to override their defaults.

* JVM_OPTS "-Xms2048m -Xmx2048m"
* MOTD "A Minecraft (All the Mods 7 0.2.41) Server Powered by Docker"
* LEVEL world

## Adding Minecraft Operators

Set the enviroment variable `OPS` with a comma separated list of players.

example:
`OPS="OpPlayer1,OpPlayer2"`

## Source
Github: https://github.com/Ratomas/all_the_mods_7
Docker: https://hub.docker.com/r/ratomas/all_the_mods_7
