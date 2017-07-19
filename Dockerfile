FROM ubuntu:14.04.5


ENV NODE_VERSION 6.9.4
ENV NPM_VERSION 3.10.10


RUN apt-get -qq update && apt-get -qq install -y \ 
    curl gconf-service lib32gcc1 lib32stdc++6 libasound2 libc6 libc6-i386 libcairo2 libcap2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libglu1-mesa libgtk2.0-0 libnspr4 libnss3 libpango1.0-0 libstdc++6 libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 zlib1g debconf xdg-utils lsb-release libpq5 xvfb \ 
    && rm -rf /var/lib/apt/lists/*


# Setup Node.js (Setup NodeSource Official PPA)
# https://github.com/nodesource/docker-node/blob/master/ubuntu/trusty/Dockerfile
RUN buildDeps='curl lsb-release python-all git apt-transport-https build-essential' && \
    apt-get update && \
    apt-get install -y --force-yes $buildDeps && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L http://git.io/n-install | N_PREFIX=/usr/local/n bash -s -- -y $NODE_VERSION
ENV PATH "$PATH:/usr/local/n/bin"

RUN npm_install=$NPM_VERSION curl -L https://www.npmjs.com/install.sh | sh

RUN npm install -g forever \
    && ln -s /usr/bin/nodejs /usr/bin/node \
    && npm config set color false


RUN mkdir -p /root/.cache/unity3d && mkdir -p /root/.local/share/unity3d
ADD get-unity.sh /app/get-unity.sh
RUN chmod +x /app/get-unity.sh && \
    /app/get-unity.sh && \
    dpkg -i /app/unity_editor.deb && \
    rm /app/unity_editor.deb
ADD unity_wrapper.sh /usr/local/bin/unity_wrapper.sh
RUN chmod +x /usr/local/bin/unity_wrapper.sh