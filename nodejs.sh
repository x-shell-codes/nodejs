########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes/scripts/nodejs                                                                         #
# Email : mailto:nodejs.script@x-shell.codes                                                                           #
# GitHub: https://github.com/x-shell-codes/nodejs                                                                      #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
  echo "${RED_LINE}$1${NORMAL_LINE}"
  echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "Nodejs install script version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/nodejs"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:nodejs.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/nodejs"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "Nodejs install script."
  echo
  echo "Options:"
  echo "-s | --source    Node.js source (ppa, apt, nvm)."
  echo
  echo "For more details see https://github.com/x-shell-codes/nodejs."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
source="ppa"

for i in "$@"; do
  case $i in
  -s=* | --source=*)
    source="${i#*=}"

    if [ "$source" != "ppa" ] && [ "$source" != "apt" ] && [ "$source" != "nvm" ]; then
      ErrorLine "Invalid source: $source"
      Help
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# APTInstall Function                                                                                                  #
########################################################################################################################
function APTInstall() {
  apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes nodejs
  apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes npm
}

########################################################################################################################
# PPAInstall Function                                                                                                  #
########################################################################################################################
function PPAInstall() {
  curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
  bash nodesource_setup.sh
  apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yesnodejs
  rm nodesource_setup.sh
}

########################################################################################################################
# NVMInstall Function                                                                                                  #
########################################################################################################################
function NVMInstall() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  nvm install v16.14.0
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}NODEJS INSTALLATION${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

apt update

if [ "$source" == "ppa" ]; then
  PPAInstall
elif [ "$source" == "apt" ]; then
  APTInstall
elif [ "$source" == "nvm" ]; then
  NVMInstall
fi

echo "${YELLOW_LINE}${BRIGHT_LINE}${REVERSE_LINE}NODEJS INSTALLATION COMPLETED${NORMAL_LINE}"
npm -v
node -v
