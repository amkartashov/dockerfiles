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
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | apt-key add - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    CLOUD_SDK_REPO="cloud-sdk-stretch" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
    >  /etc/apt/sources.list.d/azure-cli.list && \
    echo "deb https://packagecloud.io/github/git-lfs/debian/ stretch main" \
    >  /etc/apt/sources.list.d/git-lfs.list && \
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" \
    > /etc/apt/sources.list.d/mongodb-org-4.0.list && \
    echo "deb https://deb.nodesource.com/node_10.x stretch main" \
    > /etc/apt/sources.list.d/nodesource.list && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    > /etc/apt/sources.list.d/yarn.list &&
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y google-cloud-sdk \
    azure-cli kubectl git-lfs mongodb-org-shell mongodb-org-tools nodejs yarn

ADD sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint
ADD init.sh /bin/init.sh
RUN chmod +x /bin/init.sh

RUN mkdir /var/run/sshd
RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
 
