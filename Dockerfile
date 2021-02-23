FROM alpine:3.11.3
LABEL maintainer="Kristoffer Ahl kristoffer.ahl@dotnetmentor.se"

ARG WORK_DIR=/work/
ARG TERRAFORM_VERSION=0.12.21
ARG DIG_VERSION=9.10.2

RUN apk --no-cache add \
  bash \
  tar \
  curl \
  jq \
  groff \
  git \
  docker \
  docker-compose

RUN curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v${DIG_VERSION}/dig.tgz | tar -xzv -C /usr/local/bin/

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && \
  chmod +x terraform && \
  mv terraform /usr/bin && \
  rm -rf terraform.zip

RUN apk add --no-cache python2 \
  && apk add --no-cache --virtual .aws-cli-deps \
  py-pip python-dev libffi-dev openssl-dev gcc libc-dev make \
  && pip install awscli \
  && apk del .aws-cli-deps

RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
