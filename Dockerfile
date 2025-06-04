ARG CI_REGISTRY_IMAGE
ARG TAG
ARG DOCKERFS_TYPE
ARG DOCKERFS_VERSION
FROM ${CI_REGISTRY_IMAGE}/${DOCKERFS_TYPE}:${DOCKERFS_VERSION}${TAG}
LABEL maintainer="florian.sipp@chuv.ch"

ARG DEBIAN_FRONTEND=noninteractive
ARG CARD
ARG CI_REGISTRY
ARG APP_NAME
ARG APP_VERSION

LABEL app_version=$APP_VERSION
LABEL app_tag=$TAG

WORKDIR /apps/${APP_NAME}

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    curl language-pack-en binutils \
    libx11-dev gettext xterm x11-apps perl \
    make csh tcsh file bc xorg xorg-dev \
    xserver-xorg-video-intel libncurses5 \
    libgomp1 libjpeg62 libpcre2-16-0 libquadmath0 \
    libxcb-icccm4 libxcb-render-util0 libxcb-render0 \
    libxcb-shape0 libxcb-xinerama0 libxcb-xinput0 \
    libxft2 libxi6 libxrender1 libxss1 && \
    curl -sSO https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/${APP_VERSION}/freesurfer_ubuntu22-${APP_VERSION}_amd64.deb && \
    dpkg -i freesurfer_ubuntu22-${APP_VERSION}_amd64.deb && \
    rm freesurfer_ubuntu22-${APP_VERSION}_amd64.deb && \
    apt-get remove -y --purge curl && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV APP_SPECIAL="terminal"
ENV APP_CMD=""
ENV PROCESS_NAME=""
ENV APP_DATA_DIR_ARRAY=""
ENV DATA_DIR_ARRAY=""
ENV CONFIG_ARRAY=".bash_profile"

HEALTHCHECK --interval=10s --timeout=10s --retries=5 --start-period=30s \
  CMD sh -c "/apps/${APP_NAME}/scripts/process-healthcheck.sh \
  && /apps/${APP_NAME}/scripts/ls-healthcheck.sh /home/${HIP_USER}/nextcloud/"

COPY ./scripts/ scripts/
COPY ./apps/${APP_NAME}/config config/

ENTRYPOINT ["./scripts/docker-entrypoint.sh"]
