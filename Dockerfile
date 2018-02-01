FROM debian:stretch
#LABEL maintainer="reyka@wustl.edu"

#Originally from:lbwang/dailybox
#LABEL maintainer="liang-bo.wang@wustl.edu"

ARG DEBIAN_FRONTEND=noninteractive

# Upgrade APT
# Configure locale and timezone
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    echo "US/Central" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata; \
    apt-get update && apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8" \
    PATH="/opt/conda/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tmux less libreadline7 gzip bzip2 gnupg2 \
    openssh-client wget curl ca-certificates rsync \
    libglib2.0-0 libxext6 libsm6 libxrender1 git vim-nox make \
    htop parallel \
    libnss-sss && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Fish shell
RUN wget -nv http://download.opensuse.org/repositories/shells:fish:release:2/Debian_9.0/Release.key -O Release.key && \
    apt-key add Release.key && \
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/ /' > /etc/apt/sources.list.d/fish.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends fish && \
    chsh -s /usr/bin/fish && \
    rm Release.key && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Miniconda3
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh -O $HOME/miniconda.sh && \
    /bin/bash $HOME/miniconda.sh -b -p /opt/conda && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    echo 'export PATH="/opt/conda/bin:$PATH"' > /etc/profile.d/conda.sh && \
    rm $HOME/miniconda.sh

# Fish shell setting
RUN git clone https://github.com/fish-shell/fish-shell.git $HOME/dotfiles && \
    cd $HOME/dotfiles && \
    /opt/conda/bin/python3 ./dotfile_setup.py \
        --only "~/.inputrc" --only "~/.editrc" --only "~/.tmux.conf" && \
    rm -rf /root/.cache

#Cross Map
RUN conda install crossmap

