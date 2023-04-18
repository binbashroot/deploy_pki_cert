#!/bin/bash

CERTFILE="/etc/pki/tls/certs/`hostname -f`.crt"
KEYFILE="/etc/pki/tls/private/`hostname -f`.key"


if [ -f ${KEYFILE} ] && [ -f ${CERTFILE} ];then
        CERT=`openssl x509 -noout -modulus -in ${CERTFILE} | openssl md5`
        KEY=`openssl rsa -noout -modulus -in ${KEYFILE} | openssl md5`
        if [ "${KEY}" == "${CERT}" ];then
                echo "valid key"
        elif [ "${KEY}" != "${CERT}" ];then
                echo "invalid key"
                exit 1
        fi
elif [ ! -f ${KEYFILE} ] || [ ! -f ${CERTFILE} ];then
        echo "Missing key or crt file"
        exit 1
fi

