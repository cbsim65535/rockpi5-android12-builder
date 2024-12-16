FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update -y 
RUN apt-get install -y openjdk-8-jdk python gnupg flex bison gperf build-essential \
zip curl liblz4-tool zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
ccache libgl1-mesa-dev libxml2-utils xsltproc unzip mtools \
pigz bc device-tree-compiler dosfstools vim-common parted udev libssl-dev \
python3 lzop swig libncurses-dev pkg-config \
protobuf-compiler libprotobuf-dev libnl-3-dev libnl-route-3-dev xz-utils \
tar libelf-dev cpio bzip2 lib32readline-dev libbz2-dev libffi-dev \
libjpeg8-dev libncurses5 libsdl1.2-dev  libxml2 \
libxml2-dev libxslt1-dev optipng pngcrush python3-dev python3-networkx \
python3-virtualenv python3-markdown rsync schedtool squashfs-tools fontconfig \
bsdmainutils cgpt clang cron git-lfs kmod lsof maven procps xdelta3 yasm \
software-properties-common sudo wget bash-completion vim

# python-pip openjdk-8-jdk git-core x11proto-core-dev lib32ncurses5-dev lib32z-dev libghc-bzlib-dev \
# htop iotop sysstat iftop emacs python-dev python-virtualenv python-networkx python-markdown lunzip u-boot-tools \
# libwxgtk3.0-dev gcc-aarch64-linux-gnu

# repo 설치
RUN curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo > /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo && \
    which repo

# pip 패키지 설치
RUN apt install -y python3-pip
RUN python3 -m pip install --upgrade pip && \
    pip install pycrypto

# 사용자 추가
ENV USER=android12-docker
ARG USER_ID=0
ARG GROUP_ID=0
RUN groupadd -g ${GROUP_ID} jenkins-docker && useradd -m -g jenkins-docker -u ${USER_ID} android12-docker

USER android12-docker

WORKDIR /rock-android12
RUN repo init -u https://github.com/radxa/manifests.git -b Android12_Radxa_rk14 -m rockchip-s-release.xml
RUN repo sync -d --no-tags -j4

WORKDIR /rock-android12

COPY ./src/bin/* ./

CMD ./build_android.sh
