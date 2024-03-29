#!/bin/bash
##
##
## ░█████╗░░█████╗░██╗███████╗██╗░░░██╗███████╗███╗░░██╗████████╗███████╗░██████╗░█████╗░
## ██╔══██╗██╔══██╗██║██╔════╝██║░░░██║██╔════╝████╗░██║╚══██╔══╝██╔════╝██╔════╝██╔══██╗
## ██║░░██║██║░░╚═╝██║█████╗░░██║░░░██║█████╗░░██╔██╗██║░░░██║░░░█████╗░░╚█████╗░██║░░╚═╝
## ██║░░██║██║░░██╗██║██╔══╝░░██║░░░██║██╔══╝░░██║╚████║░░░██║░░░██╔══╝░░░╚═══██╗██║░░██╗
## ╚█████╔╝╚█████╔╝██║██║░░░░░╚██████╔╝███████╗██║░╚███║░░░██║░░░███████╗██████╔╝╚█████╔╝
## ░╚════╝░░╚════╝░╚═╝╚═╝░░░░░░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚══════╝╚═════╝░░╚════╝░
##
##
## @author	Oscar Cifuentes Cisterna
## @copyright	Copyright © 2023 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://ocifuentesc.cl
## @github	https://github.com/ocifuentesc
##
##
#
# Certificado_SSL https://google.com
#
# google.com:443	Issuer	 C=US, O=Google Trust Services, CN=GTS CA 1O1
# google.com:443	Not Before	 Sep 17 13:30:43 2019 GMT
# google.com:443	Not After 	 Dec 10 13:30:43 2019 GMT
# ...
#
clear
PROTOCOLS="https://|ldaps://|smtps://"

TMPDIR="/tmp/uli-war-da.$$"

cleanUp () {
    rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

TMPDIR="$(mktemp -d)"

while [ $# -gt 0 ]; do
 if [ -f "$1" ]; then
  case "$1" in
      *.crt)
	  <"$1" openssl x509 -text \
          |grep -E "^\s*(Subject:|Issuer:|Not |DNS:)"\
          |(\
	    sed -e "s/^\s*//" -e 's/^\([^:]*\):/\1\t/' -e "s/DNS://g";
	    echo -e "MD5\t$(openssl x509 -noout -modulus <$1|openssl md5|sed -e "s/^[^ ]* //")"
	  )|while read l; do echo -e "$1\t$l"; done
      ;;
      *.key)
	  echo -e "$1\tMD5\t$(openssl rsa  -noout -modulus <"$1"|openssl md5|sed -e "s/^[^ ]* //")"
      ;;
  esac
 else
  H="$1"
  PR="https://"
  PO=":443"
  URL="$(echo "${H}"|grep -oE "(${PROTOCOLS})?[^:/]*(:[0-9]*)?"|head -1)"
  HPR="$(echo "${URL}"|grep -oE "${PROTOCOLS}")"
  HPO="$(echo "${URL}"|grep -oE ":[0-9]+")"
  HO="${URL}"
  if [ -n "${HPR}" ]; then
    HO="$(echo "${HO}"|sed -e "s,${HPR},,")"
  fi
  if [ -n "${HPO}" ]; then
    HO="$(echo "${HO}"|sed -e "s,${HPO},,")"
    PO="${HPO}"
  else
    case "${HPR}" in
      "https://")
        PO=":443"
        ;;
      "ldaps://")
        PO=":636"
        ;;
      "smtps://")
        PO=":587"
        ;;
    esac
  fi
  openssl </dev/zero s_client 2>/dev/null -connect "${HO}${PO}" -servername "${HO}"\
  |openssl x509 -text >"${TMPDIR}/x509_text"
  < "${TMPDIR}/x509_text" grep -E "^\s*(Subject:|Issuer:|Not |DNS:)"\
  |sed -e "s/^\s*//" -e 's/^\([^:]*\):/\1\t/' -e "s/DNS://g" -e "s/^/${HO}${PO}\t/"
  echo -e "${HO}${PO}\tMD5\t$(<"${TMPDIR}/x509_text" openssl x509 -noout -modulus|openssl md5|sed -e "s/^[^ ]* //")"
 fi
shift
done