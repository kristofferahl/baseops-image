# Global args
ARG ALPINE_VERSION=3.18.5

# /*
# base image
# */
FROM alpine:${ALPINE_VERSION}

# Set args
ARG TARGETARCH
ARG BASEOPS_VERSION
ARG BASEOPS_IMAGE

# Use tmp as workdir
WORKDIR /tmp/

# Install packages as root
USER root

# Add alpine package manifest
COPY packages.txt /etc/apk/

# Install packages based on packages.txt
RUN apk --no-cache add --update $(grep -h -v '^#' /etc/apk/packages.txt)

# Install packages manually

# figurine
ARG FIGURINE_VERSION=1.3.0
RUN curl -L https://github.com/arsham/figurine/releases/download/v${FIGURINE_VERSION}/figurine_linux_${TARGETARCH}_v${FIGURINE_VERSION}.tar.gz | tar -xzv -C . \
  && cp deploy/figurine /usr/local/bin/figurine \
  && rm -r deploy/figurine

# Copy filesystem
COPY rootfs/ /

# Enable scripts
RUN chmod +x /etc/baseops/scripts/boot
RUN chmod +x /etc/baseops/scripts/packages
ENV PATH="/etc/baseops/scripts:$PATH"

# Set final workdir
ARG WORK_DIR=/work/
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}

# Set env
ENV BASEOPS_VERSION=$BASEOPS_VERSION
ENV BASEOPS_IMAGE=$BASEOPS_IMAGE

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "boot"]
