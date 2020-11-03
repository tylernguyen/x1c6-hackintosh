#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 6 Jun, 2020
#
# Build ACPI SSDTs for XiaoMi-Pro EFI
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# Colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)
bold=$(tput bold)


# Exit on Compile Issue
function compileErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to compile dsl!"
  find . -maxdepth 1 -name "*.aml" -exec rm -rf {} + >/dev/null 2>&1
  exit 1
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  cd "$(dirname "$0")" || exit 1
}

function compile() {
  chmod +x iasl*
  echo "${green}[${reset}${magenta}${bold} Compiling ACPI Files ${reset}${green}]${reset}"
  echo
  find . -type f -maxdepth 1 -name "*.dsl" -print0 | xargs -0 -I{} ./iasl -x 10  {} || compileErr && find .. -iname '._*' -delete && rm -f ../EFI-OpenCore/EFI/OC/ACPI/*.aml && mv *.aml ../EFI-OpenCore/EFI/OC/ACPI
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
}

function main() {
  init
  compile
  enjoy
}

main
