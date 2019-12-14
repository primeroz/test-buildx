#!/usr/bin/env bash
set -e

ETCDIR=${ETCDIR:-/tmp/tor}
DATADIR=${DATADIR:-/var/lib/tor}
CONTROLDIR=${CONTROLDIR:-/run/tor}

TORRC=${ETCDIR}/torrc

# Settings
SOCKSPORT=${SOCKSPORT:-0}
CONTROLPORT=${CONTROLPORT:-0}
CONTROLSOCKET=${CONTROLDIR}/control
CONTROLSOCKETOPTS=${CONTROLSOCKETOPTS:-"GroupWritable RelaxDirModeCheck"}
COOKIEAUTH=${COOKIEAUTH:-1}
COOKIEAUTHFILEGROUPREADABLE=${COOKIEAUTHFILEGROUPREADABLE:-1}
COOKIEAUTHFILE=${CONTROLDIR}/control.authcookie
HASHEDPASSWD=${HASHEDPASSWD:-""}

LOGLEVEL=${LOGLEVEL:-notice}

cat >$TORRC<<EOF
## TOR Configuration file

EOF

printf "\n### Main Settings\n" >> $TORRC
printf "User tord\n" >> $TORRC
printf "DataDirectory ${DATADIR}\n" >> $TORRC
printf "PidFile ${CONTROLDIR}/tor.pid\n" >> $TORRC

printf "\n### SOCKS Configuration\n" >> $TORRC
printf "SocksPort ${SOCKSPORT}\n" >> $TORRC
printf "${SOCKSPOLICY}\n" >> $TORRC

printf "\n### CONTROL Configuration\n" >> $TORRC
printf "ControlPort ${CONTROLPORT}\n" >> $TORRC
printf "ControlSocket ${CONTROLSOCKET} ${CONTROLSOCKETOPTS}\n" >> $TORRC

if [[ ! -z ${HASHEDPASSWD} ]]; then
  printf "HashedControlPassword ${HASHEDPASSWD}\n" >> $TORRC
else
  printf "CookieAuthentication ${COOKIEAUTH}\n" >> $TORRC
  printf "CookieAuthFile ${COOKIEAUTHFILE}\n" >> $TORRC
  printf "CookieAuthFileGroupReadable ${COOKIEAUTHFILEGROUPREADABLE}\n" >> $TORRC
fi

printf "\n### Logging\n" >> $TORRC
printf "Log ${LOGLEVEL} stderr\n" >> $TORRC

printf "\n### DISABLE SERVICES\n" >> $TORRC
printf "\nORPort 0\n" >> $TORRC
printf "\nDirPort 0\n" >> $TORRC

## Once you have configured a hidden service, you can look at the
## contents of the file ".../hidden_service/hostname" for the address
## to tell people.
##
## HiddenServicePort x y:z says to redirect requests on port x to the
## address y:z.

#HiddenServiceDir /var/lib/tor/hidden_service/
#HiddenServicePort 80 127.0.0.1:80

#HiddenServiceDir /var/lib/tor/other_hidden_service/
#HiddenServicePort 80 127.0.0.1:80
#HiddenServicePort 22 127.0.0.1:22

chmod 600 $TORRC
chown tord:tord $TORRC
