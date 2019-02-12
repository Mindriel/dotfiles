#!/bin/bash

HELPERS_DIR=$(dirname "$0")/helpers
. ${HELPERS_DIR}/req_exitOnFirstFail
. ${HELPERS_DIR}/req_noSudo
. ${HELPERS_DIR}/req_noArgs

CURL_RESP=$(curl -v --silent https://google.com/ 2>&1 | grep "< date" | sed -e 's/< date: //')
echo "Locally:" && timedatectl status && echo ""
echo -e "Curled:\n  ${CURL_RESP}"
sudo date --set "${CURL_RESP}" # FORMAT="%a, %d %b %Y %H:%M:%S %Z"

TIME=`date +"%Y-%m-%d %H:%M:%S"`
echo -e "Setting RTC to:\n  ${TIME}"
sudo timedatectl set-time "${TIME}"

#sudo timedatectl set-ntp 0
#sudo timedatectl set-timezone UTC
#sudo timedatectl set-time "2017-08-10 09:52:00"
#sudo timedatectl set-timezone Europe/Warsaw
#sudo timedatectl set-ntp 1
