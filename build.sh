#!/usr/bin/env bash

# Release 2.1 Yocto complete image
YOCTO_URL=${YOCTO_URL:-http://downloadmirror.intel.com/25384/eng/edison-iotdk-image-280915.zip}
TAG=${TAG:-2.1}
NAME="${NAME:-edison-yocto}"

function err {
  echo -e "\033[91m[ERROR] $1\033[0m"
}

function info {
  echo -e "\033[92m[INFO] $1\033[0m"
}

function cd_project_root {
  if [ ! -f "${ROOT}/vagrant_auto_conf.sh" ]; then
    err "Please cd to docker-edison-yocto directory"
    exit 1
  fi
}

function assert_preconditions_met {
  for c in vagrant docker git unzip
  do
    RET=`which ${c}`
    RET=$?
    if [ "${RET}" != "0" ]; then
      err "${c} is required"
      exit 1
    fi
  done

  if [ "${YOCTO_URL}" != "" ]; then
    if [ "${TAG}" == "" ]; then
      err "TAG is required as well"
      exit 2
    fi
  fi

  docker version > /dev/null
  RET=$?
  if [ "${RET}" != "0" ]; then
    err "Please start a docker-machine or perform docker-machine env"
    exit 3
  fi
}

function prepare_fs_cooker {
  if [ ! -d "${FS_COOKER}" ]; then
    git clone https://github.com/dbaba/${FS_COOKER}.git
  else
    pushd ${FS_COOKER}
    git pull
    vagrant destroy -f
    popd
  fi
}

function prepare_yocto_rootfs {
  if [ ! -f "${LOCAL_ZIP}" ]; then
    curl -L -o ${LOCAL_ZIP} ${YOCTO_URL}
    rm -fr ${LOCAL_DIR}
  fi
  if [ ! -d ${LOCAL_DIR} ]; then
    mkdir ${LOCAL_DIR}
    pushd ${LOCAL_DIR}
    unzip ../${LOCAL_ZIP}
    RET=$?
    popd
    if [ "${RET}" != "0" ]; then
      rm -fr ${LOCAL_DIR}
    fi
  fi
}

function cook_yocto_rootfs {
  EXT4=`ls ${LOCAL_DIR}/*.ext4`
  RET=$?
  if [ "${RET}" != "0" ]; then
    err "The rootfs file is missing!"
    exit 3
  fi

  cp -f ${EXT4} ${FS_COOKER}/fs.img
  cp -f ${AUTO_CONF_SCRIPT} ${FS_COOKER}
  info "Starting vagrant..."
  pushd ${FS_COOKER}
  rm -f "${EXIT_FILE}"
  rm -f "${OUT_IMG_PATH}"
  export AUTO_CONF_SCRIPT
  vagrant up > /dev/null 2>&1 &
  while true
  do
    if [ -f "${EXIT_FILE}" ]; then
      break
    fi
    echo -en "\033[93m.\033[0m"
    sleep 3
  done
  echo -e "\033[93m/DONE\033[0m"
  popd
}

function build_docker_image {
  if [ ! -f "${OUT_IMG_PATH}" ]; then
    err "The output image file is missing!"
    exit 4
  fi
  docker rmi ${NAME}:${TAG} > /dev/null 2>&1
  rm -fr ${ROOT}/fs.img
  mkdir ${ROOT}/fs.img
  tar zxf "${OUT_IMG_PATH}" -C fs.img
  cd ${ROOT}/fs.img
  tar -c . | docker import - "${NAME}":"${TAG}"
  RET=$?
  if [ "${RET}" == "0" ]; then
    info "Done! The docker image [${NAME}:${TAG}] has been created."
  fi
}


# main
cd_project_root # Resolve ROOT

LOCAL_DIR="edison-yocto"
LOCAL_ZIP="${LOCAL_DIR}.zip"
FS_COOKER="vagrant-fs-cooker"
OUT_IMG_PATH="${FS_COOKER}/fs.img.tar.gz"
AUTO_CONF_SCRIPT="${AUTO_CONF_SCRIPT:-vagrant_auto_conf.sh}"
EXIT_FILE="${AUTO_CONF_SCRIPT}.exit"

assert_preconditions_met
prepare_fs_cooker
prepare_yocto_rootfs
cook_yocto_rootfs
build_docker_image
