#!/bin/bash

echo ${CTTIMEZONE} > /etc/timezone
ln -sf /usr/share/zoneinfo/${CTTIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# ${CTLOCALE} UTF-8/${CTLOCALE} UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=${CTLOCALE}

echo "AllowUsers ${CTUSER}" >> /etc/ssh/sshd_config
useradd --uid ${CTUSERID} --user-group --shell /bin/bash ${CTUSER}
if [ -f /home/.${CTUSER}.shadow -a \
     "$(stat --dereference --printf='%u %g %a' /home/.${CTUSER}.shadow)" == "0 0 640" ]; then
  echo ${CTUSER}:"$(cat /home/.${CTUSER}.shadow)" | chpasswd -e
else
  CTUSERPWD=${CTUSERPWD:-$(pwgen 12)}
  echo ${CTUSER}:"${CTUSERPWD}" | chpasswd
fi
passwd -u ${CTUSER}
usermod -a -G sudo ${CTUSER}

# Add pubkey
if [ "${PUBKEY}" != "none" ]; then
  echo "${PUBKEY}" >> /home/${CTUSER}/.ssh/authorized_keys
  chmod 600 /home/${CTUSER}/.ssh/authorized_keys
fi

# create additional groups
for gr_n_id in ${CTUSERGROUPS}; do
  gr_name=${gr_n_id%:*}
  gr_id=${gr_n_id#*:}
  groupadd --non-unique --gid ${gr_id} ${gr_name}
  usermod -a -G ${gr_name} ${CTUSER}
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
exec /usr/sbin/sshd -Def /etc/ssh/sshd_config
