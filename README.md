docker-edison-yocto
===

[![GitHub release](https://img.shields.io/github/release/dbaba/docker-edison-yocto.svg)](https://github.com/dbaba/docker-edison-yocto/releases/latest)
[![License MIT](https://img.shields.io/github/license/dbaba/docker-edison-yocto.svg)](http://opensource.org/licenses/MIT)

A docker image building script to create a poky-yocto edison image.

The way to build edison image is introduced in the following page:

- [yocto/edison at Docker Hub](https://hub.docker.com/r/yocto/edison/)

This script depends on vagrant so that it's possible for OSX to mount Yocto's ext4 image, which is required for building an image.

## Prerequisites

1. Docker 1.12.1+
1. Vagrant 1.8.1+

## How to build

You can build a docker image by the following command. The downloaded image version is [Release 2.1 Yocto complete image](https://software.intel.com/en-us/iot/hardware/edison/downloads) by default.

```bash
$ git clone https://github.com/dbaba/docker-edison-yocto.git
$ cd docker-edison-yocto
$ ./build.sh
```
=> edison-yocto:2.1 will be created

You can modify the URL to download by specifying `YOCTO_URL` and `TAG`.

```bash
$ git clone https://github.com/dbaba/docker-edison-yocto.git
$ cd docker-edison-yocto
$ YOCTO_URL=http://downloadmirror.intel.com/24909/eng/edison-image-ww05-15.zip TAG=2.0 ./build.sh
```
=> edison-yocto:2.0 will be created

## How to run

```bash
$ docker run -ti -v /absolute/path/to/your/host/workdir:/work --rm --name edison edison-yocto:2.1 bash

bash-4.3#
```

And you can explore Edison/Yocto container.

## Revision History
* 1.0.1
  - Fix an issue where `build.sh` no longer worked on Docker 1.10.1
* 1.0.0
  - Initial Release
  - The default image is Release 2.1 poky-yocto
