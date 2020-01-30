#!/bin/bash

# ==============================================================================
# -- Set up environment --------------------------------------------------------
# ==============================================================================

source $(dirname "$0")/Environment.sh

AWS_COPY="aws s3 cp"
DOCKER="docker"
UNTAR="tar -xvzf"

# ==============================================================================
# -- Parse arguments -----------------------------------------------------------
# ==============================================================================

DOC_STRING="Upload build for testing to S3."

USAGE_STRING="Usage: $0 [-h|--help] [--dry-run]"

OPTS=`getopt -o h --long help,dry-run -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "$USAGE_STRING" ; exit 2 ; fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    --dry-run )
      AWS_COPY="echo ${AWS_COPY}";
      DOCKER="echo ${DOCKER}";
      UNTAR="echo ${UNTAR}";
      shift ;;
    -h | --help )
      echo "$DOC_STRING"
      echo "$USAGE_STRING"
      exit 1
      ;;
    * )
      break ;;
  esac
done

REPOSITORY_TAG=$(get_git_repository_version)

LATEST_PACKAGE=CARLA_${REPOSITORY_TAG}.tar.gz
LATEST_PACKAGE_PATH=${CARLA_DIST_FOLDER}/${LATEST_PACKAGE}

S3_PREFIX=s3://carla-internal/build-testing/Linux

if [[ ${REPOSITORY_TAG} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  log "Detected tag ${REPOSITORY_TAG}."
  DEPLOY_NAME=CARLA_${REPOSITORY_TAG}.tar.gz
else
  DEPLOY_NAME=$(git log --pretty=format:'%cd_%h' --date=format:'%Y%m%d' -n 1).tar.gz
fi

log "Using package ${LATEST_PACKAGE} as ${DEPLOY_NAME}."

if [ ! -f ${LATEST_PACKAGE_PATH} ]; then
  fatal_error "Latest package not found, please run 'make package'."
fi

# ==============================================================================
# -- Upload --------------------------------------------------------------------
# ==============================================================================

DEPLOY_URI=${S3_PREFIX}/${DEPLOY_NAME}

${AWS_COPY} ${LATEST_PACKAGE_PATH} ${DEPLOY_URI}

log "Latest build uploaded to ${DEPLOY_URI}."

# ==============================================================================
# -- ...and we are done --------------------------------------------------------
# ==============================================================================

log "Success!"
