#!/bin/sh

echo $CTTIMEZONE > /etc/timezone
ln -sf /usr/share/zoneinfo/$CTTIMEZONE /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# $CTLOCALE UTF-8/$CTLOCALE UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$CTLOCALE

echo "AllowUsers $CTUSER" >> /etc/ssh/sshd_config
useradd --uid $CTUSERID --user-group --shell /bin/bash $CTUSER
if [ -f /home/.$CTUSER.shadow -a \
     "$(stat --dereference --printf='%u %g %a' /home/.$CTUSER.shadow)" == "0 0 640" ]; then
  echo $CTUSER:"$(cat /home/.$CTUSER.shadow)" | chpasswd -e
else
  echo $CTUSER:"$CTUSERPWD" | chpasswd
fi
passwd -u $CTUSER
usermod -a -G sudo $CTUSER

# Add pubkey
if [ "$PUBKEY" != "none" ]; then
  echo "$PUBKEY" >> /home/$CTUSER/.ssh/authorized_keys
  chmod 600 /home/$CTUSER/.ssh/authorized_keys
fi

# Run init script in background 
tmux new-session -d -s init '/bin/init.sh'

# start ssh daemon
exec /usr/sbin/sshd -Def /etc/ssh/sshd_config
