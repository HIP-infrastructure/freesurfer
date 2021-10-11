ARG CI_REGISTRY_IMAGE
ARG DAVFS2_VERSION
FROM ${CI_REGISTRY_IMAGE}/nc-webdav:${DAVFS2_VERSION}
LABEL maintainer="manik.bhattacharjee@univ-grenoble-alpes.fr"

ARG DEBIAN_FRONTEND=noninteractive
ARG CARD
ARG CI_REGISTRY
ARG APP_NAME
ARG APP_VERSION

LABEL app_version=$APP_VERSION

WORKDIR /apps/${APP_NAME}

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    curl language-pack-en binutils libx11-dev gettext \
    xterm x11-apps perl make csh tcsh file bc xorg \
    xorg-dev xserver-xorg-video-intel libncurses5 \
    libgomp1  libice6 libjpeg62 libsm6 \
    libxft2 libxmu6 libxt6 && \
    curl -O https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/${APP_VERSION}/freesurfer_${APP_VERSION}_amd64.deb && \
    dpkg -i freesurfer_${APP_VERSION}_amd64.deb && \
    rm freesurfer_${APP_VERSION}_amd64.deb && \
    apt-get remove -y --purge curl && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV APP_SHELL="yes"
ENV APP_CMD=""
ENV PROCESS_NAME=""
ENV DIR_ARRAY="/usr/local/freesurfer/${APP_VERSION}/subjects"
ENV CONFIG_ARRAY=".bash_profile"

HEALTHCHECK --interval=10s --timeout=10s --retries=5 --start-period=30s \
  CMD sh -c "/apps/${APP_NAME}/scripts/process-healthcheck.sh \
  && /apps/${APP_NAME}/scripts/ls-healthcheck.sh /home/${HIP_USER}/nextcloud/"

COPY ./scripts/ scripts/
COPY ./apps/${APP_NAME}/config config/

ENTRYPOINT ["./scripts/docker-entrypoint.sh"]
