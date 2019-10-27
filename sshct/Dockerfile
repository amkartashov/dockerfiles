FROM debian:9

VOLUME /home
EXPOSE 22
ENTRYPOINT ["/bin/entrypoint"]

ENV CTUSER me
ENV CTUSERID 1000
ENV CTUSERPWD ""
ENV CTTIMEZONE Asia/Novosibirsk
ENV CTLOCALE ru_RU.UTF-8
ENV PUBKEY none

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openssh-server bash tmux curl sudo less vim gnupg ca-certificates \
    dialog locales man bash-completion wget apt-file telnet \
    dnsutils git pwgen python bc unzip zip graphviz whois mysql-client \
    lsof file postgresql-client build-essential htop apt-transport-https \
    lsb-release software-properties-common dirmngr debian-archive-keyring \
    && \
    curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key add - && \
    apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
        --keyserver packages.microsoft.com \
        --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF && \
    curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
    CLOUD_SDK_REPO="cloud-sdk-stretch" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
    >  /etc/apt/sources.list.d/azure-cli.list && \
    echo "deb https://packagecloud.io/github/git-lfs/debian/ stretch main" \
    >  /etc/apt/sources.list.d/git-lfs.list && \
    apt-get update && \
    apt-get install -y google-cloud-sdk azure-cli kubectl git-lfs

ADD sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint
ADD init.sh /bin/init.sh
RUN chmod +x /bin/init.sh

RUN mkdir /var/run/sshd
RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
 
