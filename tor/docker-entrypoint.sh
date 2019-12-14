#!/bin/bash
set -e

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  echo "===> Executing entrypoint hooks under docker-entrypoint.d"
  /bin/run-parts --verbose --exit-on-error --regex '\.(sh|rb|py)$' "$DIR"
  echo "===> End of hooks"
fi

echo "===> Executing ARGS \"$@\""
exec "$@"
