#!/bin/bash

if [ -f requirements.txt ]; then
  echo == Installing required python modules
  pip3 --quiet install --requirement requirements.txt
fi

if [ -f requirements.yml ]; then
  echo == Installing required roles from ansible galaxy
  ansible-galaxy install --role-file requirements.yml
fi

if [ $# -eq 0 ]; then
  echo No commands passed, running shell
  exec bash
fi

echo == Running command: "$@"

exec "$@"
