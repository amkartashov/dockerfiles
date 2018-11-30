#!/bin/sh

exec >>/home/.init.log 2>&1

echo ====================== INIT START
date

# Install additional packages
echo ====== Installing additional packages
if [ -f /home/.packages ]; then
  cat /home/.packages | xargs --max-args=1 apt-get install -y
fi

# Run custom scripts /home/.scripts/*.sh
if [ -d /home/.scripts ]; then
  find /home/.scripts -name '*.sh' | while read s; do
    if [ -x "$s" ]; then # if script is executable
      echo ====== $(date)
      echo Running $s
      $s <&-             # run it with closed stdin, so it does not consume `find` output
    else
      echo ====== $(date)
      echo Skipping non-executable $s
    fi
  done
fi

echo ====================== INIT END
