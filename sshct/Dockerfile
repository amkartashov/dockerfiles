FROM debian:10

VOLUME /home
EXPOSE 22
ENTRYPOINT ["/bin/entrypoint"]

ENV CTUSER me
ENV CTUSERID 1000
ENV CTUSERPWD ""
ENV CTTIMEZONE Asia/Novosibirsk
ENV CTLOCALE ru_RU.UTF-8
ENV PUBKEY none

# 9DA31620334BD75D9DCB49F368818C72E52529D4 - MongoDB 4.0 Release Signing Key
# 2EE0EA64E40A89B84B2DF73499E82A75642AC823 - sbt build tool key
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openssh-server bash tmux curl sudo less vim gnupg ca-certificates \
    dialog locales man bash-completion wget apt-file telnet \
    dnsutils git pwgen python bc unzip zip graphviz whois mariadb-client \
    lsof file postgresql-client build-essential htop apt-transport-https \
    lsb-release software-properties-common dirmngr debian-archive-keyring \
    openjdk-11-jdk python-pip python3-pip jq netcat strace apache2-utils \
    gdb redis-tools tree protobuf-compiler golang-goprotobuf-dev ruby-full \
    && \
    curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    curl -sS https://www.mongodb.org/static/pgp/server-4.2.asc \
    | apt-key add - && \
    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | apt-key add - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    curl -sS https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    DEB_RELEASE=$(lsb_release -cs) && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $DEB_RELEASE main" \
    >  /etc/apt/sources.list.d/azure-cli.list && \
    echo "deb https://packagecloud.io/github/git-lfs/debian/ $DEB_RELEASE main" \
    >  /etc/apt/sources.list.d/git-lfs.list && \
    echo "deb http://repo.mongodb.org/apt/debian $DEB_RELEASE/mongodb-org/4.2 main" \
    > /etc/apt/sources.list.d/mongodb-org-4.2.list && \
    echo "deb https://deb.nodesource.com/node_12.x $DEB_RELEASE main" \
    > /etc/apt/sources.list.d/nodesource.list && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    > /etc/apt/sources.list.d/yarn.list && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" \
    > /etc/apt/sources.list.d/bazel.list && \
    echo "deb https://dl.bintray.com/sbt/debian /" \
    > /etc/apt/sources.list.d/sbt.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y google-cloud-sdk \
    azure-cli kubectl git-lfs mongodb-org-shell mongodb-org-tools nodejs yarn \
    bazel bazel-1.2.1 bazel-2.1.1 bazel-2.2.0 bazel-3.0.0 sbt

ADD sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint
ADD init.sh /bin/init.sh
RUN chmod +x /bin/init.sh

RUN mkdir /var/run/sshd
RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

