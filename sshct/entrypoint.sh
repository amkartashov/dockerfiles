#!/bin/bash

set -o errexit  # Exit immediately if a pipeline ... exits with a non-zero status
set -o pipefail # ... return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status
set -o nounset  # Treat unset variables ... as an error

# set defaults
: ${CT_TIMEZONE:=UTC}
: ${CT_LOCALE:=en_US.utf8}
: ${CT_USER:=me}
: ${CT_USERID:=1000}
: ${CT_USERPUBKEY:=}
: ${CT_USERPWD:=$(pwgen 12)}
: ${CT_USERGROUPS:=}
: ${CT_SSHPORT:=22}

echo ${CT_TIMEZONE} > /etc/timezone
ln -sf /usr/share/zoneinfo/${CT_TIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# ${CT_LOCALE} UTF-8/${CT_LOCALE} UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=${CT_LOCALE}

echo "AllowUsers ${CT_USER}" >> /etc/ssh/sshd_config
useradd --create-home --uid ${CT_USERID} --user-group --shell /usr/bin/tmux ${CT_USER}
if [ -f /home/.${CT_USER}.shadow -a ]; then
  if ["$(stat --dereference --printf='%u %g %a' /home/.${CT_USER}.shadow)" == "0 0 640" ]; then
    echo ${CT_USER}:"$(cat /home/.${CT_USER}.shadow)" | chpasswd -e
  else
    echo "!!! /home/.${CT_USER}.shadow has wrong permissions, ignore"
  fi
else
  echo ${CT_USER}:"${CT_USERPWD}" | chpasswd
fi
passwd -u ${CT_USER}
usermod -a -G sudo ${CT_USER}

# Add pubkey
if [ "${CT_USERPUBKEY}" != "" ]; then
  if ! grep -F "${CT_USERPUBKEY}" /home/${CT_USER}/.ssh/authorized_keys; then
    mkdir -p /home/${CT_USER}/.ssh/
    echo "${CT_USERPUBKEY}" >> /home/${CT_USER}/.ssh/authorized_keys
    chmod 600 /home/${CT_USER}/.ssh/authorized_keys
    chown -R ${CT_USER}:${CT_USER} /home/${CT_USER}/.ssh
  fi
fi

# create additional groups
for gr_n_id in ${CT_USERGROUPS}; do
  gr_name=${gr_n_id%:*}
  gr_id=${gr_n_id#*:}
  groupadd --non-unique --gid ${gr_id} ${gr_name}
  usermod -a -G ${gr_name} ${CT_USER}
done

# Run init script in background 
tmux new-session -d -s init '/bin/init.sh'

# create sshd keys, copied from postinstall script
create_key() {
    msg="$1"
    shift
    file="$1"
    shift

    if [ ! -f "${file}" ] ; then
        echo -n ${msg}
        ssh-keygen -q -f "${file}" -N '' "$@"
        echo
        if which restorecon >/dev/null 2>&1; then
            restorecon "${file}" "${file}.pub"
        fi
        ssh-keygen -l -f "${file}.pub"
    fi
}

mkdir -p /home/.sshkeys

create_key "Creating SSH2 RSA key; this may take some time ..." \
  /home/.sshkeys/ssh_host_rsa_key -t rsa
create_key "Creating SSH2 ECDSA key; this may take some time ..." \
  /home/.sshkeys/ssh_host_ecdsa_key -t ecdsa
create_key "Creating SSH2 ED25519 key; this may take some time ..." \
  /home/.sshkeys/ssh_host_ed25519_key -t ed25519

# start ssh daemon
exec /usr/sbin/sshd -Def /etc/ssh/sshd_config -p ${CT_SSH_PORT:-22}
