FROM ubuntu:20.04

VOLUME /home
EXPOSE 22
ENTRYPOINT ["/bin/entrypoint"]

ENV CTUSER me
ENV CTUSERID 1000
ENV CTUSERPWD ""
ENV CTTIMEZONE Asia/Novosibirsk
ENV CTLOCALE ru_RU.UTF-8
ENV PUBKEY none

# Unminimize, see https://wiki.ubuntu.com/Minimal
RUN yes | unminimize

# Add tools for apt and basic prereqs
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl wget ca-certificates \
    apt-file apt-transport-https \
    lsb-release software-properties-common \
    dirmngr debian-archive-keyring gnupg \
    dialog locales \
    openssh-server bash tmux sudo \
    && apt-get clean

# Copy init scripts
ADD sshd_config /etc/ssh/sshd_config
ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint
ADD init.sh /bin/init.sh
RUN chmod +x /bin/init.sh
RUN mkdir /var/run/sshd
RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# Add repositories
RUN DEB_RELEASE=$(lsb_release --short --codename) \
    DEB_VERSION_ID=$(lsb_release --short --release) \
    && \
    echo == packages.cloud.google.com && \
    curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && \
    echo == packages.microsoft.com && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $DEB_RELEASE main" \
    >  /etc/apt/sources.list.d/azure-cli.list \
    && \
    echo == git-lfs && \
    curl -L https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ $DEB_RELEASE main" \
    >  /etc/apt/sources.list.d/github_git-lfs.list \
    && \
    echo == mongodb && \
    curl -sS https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $DEB_RELEASE/mongodb-org/4.4 multiverse" \
    > /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && \
    echo == nodejs && \
    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_12.x $DEB_RELEASE main" \
    > /etc/apt/sources.list.d/nodesource.list \
    && \
    echo == yarn && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    > /etc/apt/sources.list.d/yarn.list \
    && \
    echo == buildah && \
    curl -sSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${DEB_VERSION_ID}/Release.key \
    | sudo apt-key add - && \
    echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${DEB_VERSION_ID}/ /" \
    > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list \
    && echo done

# Additional packages
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    less vim bc jq man bash-completion \
    uuid-runtime file apache2-utils \
    tree htop lsof strace psmisc \
    unzip zip lrzip \
    pwgen xkcdpass wamerican kpcli oathtool \
    telnet dnsutils iputils-ping iputils-tracepath ipcalc iproute2 netcat whois \
    ncdu mc \
    mariadb-client postgresql-client redis-tools \
    libvirt-clients \
    git build-essential gdb \
    python python3-pip libpython3-dev \
    openjdk-11-jdk \
    protobuf-compiler golang-goprotobuf-dev \
    clang lldb lld \
    clojure leiningen \
    cmake cmake-doc ninja-build \
    qemu binfmt-support qemu-user-static \
    gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu g++-aarch64-linux-gnu \
    \
    google-cloud-sdk kubectl \
    azure-cli \
    git-lfs \
    mongodb-org-shell mongodb-org-tools \
    nodejs \
    yarn \
    buildah \
    && apt-get clean

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && apt-get clean



