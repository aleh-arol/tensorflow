#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../../../.."

DOWNLOADS_DIR=tensorflow/lite/delegates/gpu/downloads
BZL_FILE_PATH=tensorflow/workspace.bzl

# Ensure it is being run from repo root
if [ ! -f $BZL_FILE_PATH ]; then
  echo "Could not find ${BZL_FILE_PATH}":
  echo "Likely you are not running this from the root directory of the repository.";
  exit 1;
fi

FP16_URL="https://github.com/Maratyszcza/FP16/archive/febbb1c163726b5db24bed55cc9dc42529068997.tar.gz"
ABSL_URL="$(grep -o 'https://github.com/abseil/abseil-cpp/.*tar.gz' "${BZL_FILE_PATH}" | head -n1)"
FLATBUFFERS_URL="https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/flatbuffers/archive/v1.11.0.tar.gz"


download_and_extract() {
  local usage="Usage: download_and_extract URL DIR"
  local url="${1:?${usage}}"
  local dir="${2:?${usage}}"
  echo "downloading ${url}" >&2
  mkdir -p "${dir}"
  if [[ "${url}" == *gz ]]; then
    curl -Ls "${url}" | tar -C "${dir}" --strip-components=1 -xz
  elif [[ "${url}" == *zip ]]; then
    tempdir=$(mktemp -d)
    tempdir2=$(mktemp -d)

    curl -L ${url} > ${tempdir}/zipped.zip
    unzip ${tempdir}/zipped.zip -d ${tempdir2}

    # If the zip file contains nested directories, extract the files from the
    # inner directory.
    if ls ${tempdir2}/*/* 1> /dev/null 2>&1; then
      # unzip has no strip components, so unzip to a temp dir, and move the
      # files we want from the tempdir to destination.
      cp -R ${tempdir2}/*/* ${dir}/
    else
      cp -R ${tempdir2}/* ${dir}/
    fi
    rm -rf ${tempdir2} ${tempdir}
  fi

  # Delete any potential BUILD files, which would interfere with Bazel builds.
  find "${dir}" -type f -name '*BUILD' -delete
}


download_and_extract "${FP16_URL}" "${DOWNLOADS_DIR}/FP16"
download_and_extract "${ABSL_URL}" "${DOWNLOADS_DIR}/absl"
download_and_extract "${FLATBUFFERS_URL}" "${DOWNLOADS_DIR}/flatbuffers"
