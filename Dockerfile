ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
ARG PRUSASLICER_RELEASE_VERSION="2.4.2+linux-x64-GTK3-202204251120"
ARG PRUSASLICER_VERSION="2.4.2"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

User root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

COPY ./src/ubuntu/install/prusaslicer/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh

RUN curl -O https://github.com/prusa3d/PrusaSlicer/releases/download/version_${PRUSASLICER_VERSION}/PrusaSlicer-${PRUSASLICER_RELEASE_VERSION}.AppImage && \
    mkdir -p ${HOME}/Applications && \
    mv PrusaSclier-${PRUSASLICER_RELEASE_VERSION}.AppImage ${HOME}/.local/bin/PrusaSlicer.AppImage && \
    chmod +x $HOME/.local/bin/PrusaSlicer.AppImage

ENV KASM_RESTRICTRED_FILE_CHOOSER=1
COPY ./src/ubuntu/install/gtk/ $INST_SCRIPTS/gtk/
RUN bash $INST_SCRIPTS/gtk/install_restricted_file_chooser.sh

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
