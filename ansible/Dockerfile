FROM ubuntu:20.04

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gcc python3-dev python3-pip libkrb5-dev krb5-user openssh-client && \
  apt-get clean && \
  pip3 install --upgrade pip virtualenv pywinrm[kerberos] pywinrm ansible

RUN mkdir /ansible
WORKDIR /ansible
VOLUME /ansible

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
