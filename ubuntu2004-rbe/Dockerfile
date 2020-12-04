FROM ubuntu:20.04

ARG GOVERSION=1.15.5

# https://github.com/GoogleCloudPlatform/layer-definitions/tree/master/layers/ubuntu1804
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    clang libclang-dev libc++-10-dev llvm llvm-dev llvm-dev libomp-dev \
    gcc libasan6 libc6 libc6-dev libatomic1 libc-dev-bin libcilkrts5 \
    libgcc-7-dev libgcc-8-dev libgcc-9-dev libgcc-10-dev libgomp1 libitm1 \
    liblsan0 libmpx2 libquadmath0 libstdc++-7-dev libstdc++-8-dev \
    libstdc++-9-dev libstdc++-10-dev libtsan0 libubsan0 linux-libc-dev \
    ca-certificates-java fontconfig-config fonts-dejavu-core java-common \
    libavahi-client3 libavahi-common-data libavahi-common3 libbsd0 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libjpeg-turbo8 libjpeg8 \
    liblcms2-2 libnspr4 libnss3 libpcsclite1 libpng16-16 libx11-6 libx11-data \
    libxau6 libxcb1 libxdmcp6 libxext6 libxi6 libxrender1 libxtst6 \
    openjdk-11-jdk-headless openjdk-11-jre-headless ucf x11-common \
    distro-info-data gir1.2-glib-2.0 gpg gpgconf iso-codes libapt-pkg-dev \
    libassuan0 libc-dev-bin libc6 libc6-dev libdbus-1-3 libexpat1 \
    libexpat1-dev libgirepository-1.0-1 libglib2.0-0 libmpdec2 libpython2-dev \
    libpython3-dev libpython2.7 libpython2.7-dev libpython2.7-minimal \
    libpython2.7-stdlib libpython3-stdlib libpython3.8 libpython3.8-dev \
    libpython3.8-minimal libpython3.8-stdlib libreadline8 linux-libc-dev \
    lsb-release mime-support python python-apt-common python-dev \
    python-pkg-resources python-setuptools python2.7 python2.7-dev \
    python2.7-minimal python3 python3-apt python3-dbus python3-gi \
    python3-minimal python3-software-properties python3.8 python3.8-dev \
    python3.8-minimal readline-common software-properties-common zlib1g-dev \
    binutils binutils-common binutils-x86-64-linux-gnu ca-certificates ed file \
    git git-man less libbinutils libbsd0 libcurl3-gnutls libedit2 \
    liberror-perl libexpat1 libgdbm-compat4 libgdbm6 libmagic-mgc libmagic1 \
    libperl5.30 libssl1.1 locales locales-all netcat netcat-traditional \
    openssh-client patch perl perl-base perl-modules-5.30 unzip wget zip

RUN wget -qO- -c https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz | tar xzf - -C /usr/local

