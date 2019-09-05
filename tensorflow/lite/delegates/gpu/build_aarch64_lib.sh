set -x
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TENSORFLOW_DIR="${SCRIPT_DIR}/../../../.."

make -j4 TARGET=aarch64 -C "${TENSORFLOW_DIR}" -f tensorflow/lite/delegates/gpu/Makefile
