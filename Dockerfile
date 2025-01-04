FROM kasmweb/ubuntu-jammy-desktop:1.16.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
# Install System Dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create Python symlink
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install NodeJS v18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Clone and Install MeshChat
RUN cd /opt && \
    git clone https://github.com/liamcottle/reticulum-meshchat && \
    cd reticulum-meshchat && \
    npm install --omit=dev && \
    npm run build-frontend && \
    pip install -r requirements.txt

# Create necessary directories and set permissions
RUN mkdir -p /opt/reticulum-meshchat/storage && \
    mkdir -p /opt/reticulum-meshchat/.reticulum && \
    chown -R 1000:1000 /opt/reticulum-meshchat

# Copy custom Reticulum config
COPY config /opt/reticulum-meshchat/.reticulum/config
RUN chown 1000:1000 /opt/reticulum-meshchat/.reticulum/config

# Create startup script for MeshChat
RUN echo '#!/bin/bash\n\
cd /opt/reticulum-meshchat\n\
python3 meshchat.py --headless --host=0.0.0.0 --storage-dir=/opt/reticulum-meshchat/storage --reticulum-config-dir=/opt/reticulum-meshchat/.reticulum &\n\
sleep 5\n\
google-chrome --new-window http://localhost:8000' > /usr/local/bin/start-meshchat.sh && \
    chmod +x /usr/local/bin/start-meshchat.sh

# Create desktop entry
RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Name=Reticulum MeshChat\n\
Comment=Reticulum MeshChat Web Interface\n\
Exec=/usr/local/bin/start-meshchat.sh\n\
Icon=utilities-terminal\n\
Terminal=false\n\
Type=Application\n\
Categories=Network;" > /usr/share/applications/meshchat.desktop

# Copy desktop file to Desktop
RUN cp /usr/share/applications/meshchat.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/meshchat.desktop \
    && chown 1000:1000 $HOME/Desktop/meshchat.desktop

# Setup startup script
RUN echo "/usr/bin/desktop_ready && /usr/local/bin/start-meshchat.sh" > $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown -R 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000