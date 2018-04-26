#!/bin/bash
#set -e # chown may fail on readonly mounts

if [[ -f "$CA_CERTIFICATE" ]]; then
	keytool -import -keystore ${JAVA_HOME}/lib/security/cacerts -storepass changeit \
	    -file $CA_CERTIFICATE -alias custom-root-ca -noprompt >/dev/null

	if [[ -f "$CERTIFICATE" && -f "$CERTIFICATE_KEY" ]]; then
		mkdir -p /usr/share/elasticsearch/config/certs
		openssl pkcs12 -export -in $CERTIFICATE -inkey $CERTIFICATE_KEY \
		    -out keystore.p12 -CAfile $CA_CERTIFICATE -caname "Root CA" -password pass:$STORE_PASS
		keytool -importkeystore \
		    -deststorepass $STORE_PASS -destkeypass $KEY_PASS -destkeystore /usr/share/elasticsearch/config/certs/keystore.jks \
	        -srckeystore keystore.p12 -srcstoretype PKCS12 -srcstorepass $STORE_PASS
	    rm -rf keystore.p12
	fi
fi

if [[ "$@" == 'eswrapper' ]]; then
        find /usr/share/elasticsearch/config -type f -exec chmod 600 {} ';' &> /dev/null
        find /usr/share/elasticsearch/config -type d -exec chmod 700 {} ';' &> /dev/null
        chown -R elasticsearch /usr/share/elasticsearch/config 2> /dev/null
fi

exec /usr/local/bin/docker-entrypoint.sh "$@"
