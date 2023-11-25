# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
WHITE='\033[1;37m'
DEFAULT='\033[1;39m'
NC='\033[0m' # No Color

# Logger
logInternal() {
    local utcTime=$(date -u -Iseconds)
    local color=${1}
    local level=${2}
    local message=${3}
    printf "%b[%s] [%s] %s%b\n" "${color}" "${utcTime}" "${level}" "${message}" "${NC}"
}

logDebug() {
    logInternal "${DEFAULT}" "DEBUG" "${1}"
}

logSuccess() {
    logInternal "${GREEN}" "SUCCESS" "${1}"
}

logInfo() {
    logInternal "${WHITE}" "INFO" "${1}"
}

logWarning() {
    logInternal "${YELLOW}" "WARN" "${1}"
}

logError() {
    logInternal "${RED}" "ERROR" "${1}"
}
