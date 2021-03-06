FROM gitpod/workspace-full-vnc
                    
USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/

# RUN sudo apt-get -q update &&  sudo apt-get install -yq SOMETHING && sudo rm -rf /var/lib/apt/lists/*
#

# Now this has stopped working too for no reason I can see.
# RUN sudo apt-get install -y tcl8.5-dev tk8.5-dev \
#     && rm -rf /var/lib/apt/lists/*

# While these commands do work to install FAHClient, it won't run in this environment because of an "Operation not permitted" error.
# ENV FAHC_MAJOR 7.6
# ENV FAHC_VERSION 7.6.13

# COPY --chown=gitpod:gitpod fahclient.selections /tmp
# RUN sudo dpkg-reconfigure debconf -f noninteractive -p critical && sudo debconf-set-selections /tmp/fahclient.selections

# RUN wget -O fahc.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAHC_MAJOR}/fahclient_${FAHC_VERSION}_amd64.deb \
#     && sudo dpkg -i fahc.deb
