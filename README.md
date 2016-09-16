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

You can build a docker image by the following command. The downloaded image version is [Release 3.5 Yocto complete image](https://software.intel.com/en-us/iot/hardware/edison/downloads) by default.

```bash
$ git clone https://github.com/dbaba/docker-edison-yocto.git
$ cd docker-edison-yocto
$ ./build.sh
```
=> edison-yocto:3.5 will be created

The following is the typical output of the command.

```
$ ./build.sh
Cloning into 'vagrant-fs-cooker'...
remote: Counting objects: 61, done.
remote: Compressing objects: 100% (18/18), done.
remote: Total 61 (delta 7), reused 0 (delta 0), pack-reused 43
Unpacking objects: 100% (61/61), done.
Checking connectivity... done.
[INFO] Starting vagrant...
~/work/docker-edison-yocto/vagrant-fs-cooker ~/work/docker-edison-yocto
.........................../DONE
~/work/docker-edison-yocto
./usr/share/terminfo/h/hp2621a: Can't create 'usr/share/terminfo/h/hp2621a'
./usr/share/terminfo/h/hp2621: Can't create 'usr/share/terminfo/h/hp2621'
./usr/share/terminfo/P/P9: Can't create 'usr/share/terminfo/P/P9'
./usr/share/terminfo/P/P8-W: Can't create 'usr/share/terminfo/P/P8-W'
./usr/share/terminfo/P/P9-8: Can't create 'usr/share/terminfo/P/P9-8'
./usr/share/terminfo/P/P14-M: Can't create 'usr/share/terminfo/P/P14-M'
./usr/share/terminfo/P/P14-M-W: Can't create 'usr/share/terminfo/P/P14-M-W'
./usr/share/terminfo/P/P12-M: Can't create 'usr/share/terminfo/P/P12-M'
./usr/share/terminfo/P/P9-W: Can't create 'usr/share/terminfo/P/P9-W'
./usr/share/terminfo/P/P14: Can't create 'usr/share/terminfo/P/P14'
./usr/share/terminfo/P/P8: Can't create 'usr/share/terminfo/P/P8'
./usr/share/terminfo/P/P12-M-W: Can't create 'usr/share/terminfo/P/P12-M-W'
./usr/share/terminfo/P/P9-8-W: Can't create 'usr/share/terminfo/P/P9-8-W'
./usr/share/terminfo/n/ncrvt100wpp: Can't create 'usr/share/terminfo/n/ncrvt100wpp'
./usr/share/terminfo/n/ncrvt100wan: Can't create 'usr/share/terminfo/n/ncrvt100wan'
./usr/share/terminfo/n/ncr260vt300wpp: Can't create 'usr/share/terminfo/n/ncr260vt300wpp'
./usr/share/terminfo/2/2621: Can't create 'usr/share/terminfo/2/2621'
./usr/share/terminfo/2/2621a: Can't create 'usr/share/terminfo/2/2621a'
./usr/share/terminfo/2/2621A: Can't create 'usr/share/terminfo/2/2621A'
./usr/share/terminfo/2/2621-wl: Can't create 'usr/share/terminfo/2/2621-wl'
./usr/share/terminfo/l/lft-pc850: Can't create 'usr/share/terminfo/l/lft-pc850'
tar: Error exit delayed from previous errors.
tar: install_social: could not open file: Permission denied
tar: say: could not open file: Permission denied
tar: sudo: could not open file: Permission denied
tar: update_libwyliodrin: could not open file: Permission denied
tar: update_streams: could not open file: Permission denied
tar: settings_arduinogalileo.json: could not open file: Permission denied
tar: settings_edison.json: could not open file: Permission denied
tar: settings_minnowboardmax.json: could not open file: Permission denied
tar: settings_raspberrypi.json: could not open file: Permission denied
tar: settings_udooneo.json: could not open file: Permission denied
sha256:34cf1a83a4db9f5ed0d8a720beb6f2dcf60a23a31dfff046f67b46c5f75656af
[INFO] Done! The docker image [edison-yocto:3.5] has been created.
```

You can ignore tar errors as long as the docker image is created.

You can modify the URL to download by specifying `YOCTO_URL` and `TAG`.

```bash
$ git clone https://github.com/dbaba/docker-edison-yocto.git
$ cd docker-edison-yocto
$ YOCTO_URL=http://downloadmirror.intel.com/25384/eng/edison-iotdk-image-280915.zip TAG=2.1 ./build.sh
```
=> edison-yocto:2.1 will be created

## How to run

```bash
$ docker run -ti -v $(pwd):/work --rm --name edison edison-yocto:3.5 bash

bash-4.3#
```

And you can explore Edison/Yocto container.

## Revision History
* 1.1.0
  - Bump up Yocto version to 3.5
* 1.0.1
  - Fix an issue where `build.sh` no longer worked on Docker 1.10.1
* 1.0.0
  - Initial Release
  - The default image is Release 2.1 poky-yocto
