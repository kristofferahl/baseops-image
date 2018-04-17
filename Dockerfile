FROM alpine:3.7

LABEL maintainer="Kristoffer Ahl kristoffer.ahl@dotnetmentor.se"

ARG ONEPASSWORD_VERSION=v0.4
ARG TERRAFORM_VERSION=0.11.7
ARG DIG_VERSION=9.10.2
ARG WORK_DIR=/work/

ENV AWS_MFA_WORK_DIR=${WORK_DIR}

RUN apk --no-cache add \
  bash \
  jq \
  curl \
  git \
  docker \
  python \
  py-pip \
  groff \
  tar

RUN curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v${DIG_VERSION}/dig.tgz | tar -xzv -C /usr/local/bin/

RUN pip install --upgrade pip && \
  pip install awscli && \
  pip install docker-compose

RUN curl https://cache.agilebits.com/dist/1P/op/pkg/${ONEPASSWORD_VERSION}/op_linux_386_${ONEPASSWORD_VERSION}.zip -o op.zip && \
  unzip op.zip && \
  chmod +x op && \
  mv op /usr/bin && \
  rm -rf op.zip op.sig

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && \
  chmod +x terraform && \
  mv terraform /usr/bin && \
  rm -rf terraform.zip

RUN mkdir -p /var/lib/aws-mfa && \
  curl https://raw.githubusercontent.com/kristofferahl/aws-mfa/master/aws-mfa.sh > /var/lib/aws-mfa/aws-mfa.sh

RUN mkdir -p /root/.op/
RUN chown -R $USER:$(id -gn $USER) /root/.op/

RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
