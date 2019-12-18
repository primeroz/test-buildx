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



extract_hidden_services_v2() {
  local services=()
  for e in `compgen -e`
  do
    if [[ $e =~ ^.+_TOR_SERVICE_VERSION$ ]] && [[ "$(eval echo \${${e}})" == "2" ]]; then
      services+=($(echo $e|sed -e 's/_TOR_SERVICE_VERSION//'))
    fi
  done

  for s in "${services[@]}"
  do
    local dir="$DATADIR/hidden_services/$s"
    local hosts="$(eval echo \${${s}_TOR_SERVICE_HOSTS})"
    local auth="$(eval echo \${${s}_TOR_SERVICE_AUTH})"
    if [[ ! "x$(eval echo \${${s}_TOR_SERVICE_HOSTS})" == "x" ]]; then
      printf "\nHiddenServiceDir $dir" >> $TORRC
      printf "\nHiddenServicePort $hosts" >> $TORRC
      printf "\nHiddenServiceVersion 2" >> $TORRC
      if [[ "x$auth" == "xbasic" ]] || [[ "x$auth" == "xstealth" ]]; then
        printf "\nHiddenServiceAuthorizeClient $auth client" >> $TORRC
      fi
    fi
  done

}

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

printf "\n ### HIDDEN SERVICES v2" >> $TORRC
extract_hidden_services_v2
printf "\n\n### END of config\n" >> $TORRC

chmod 600 $TORRC
chown tord:tord $TORRC
