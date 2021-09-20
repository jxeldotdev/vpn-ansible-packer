FROM python:3.9-buster AS base

RUN apt update -y
RUN apt install -y apt-transport-https
RUN set -x \ 
    && apt install -y \
        ca-certificates \
        curl \
        groff-base \
        gzip \ 
        libbz2-1.0 \
        libc6 \
        libffi6 \
        liblzma5 \
        libncursesw6 \
        libreadline7 \
        libsqlite3-0 \
        libssl1.1 \
        libtinfo6 \
        procps \
        tar \
        wget \
        zlibc \
        curl \
        git \
        ;

RUN set -x \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip "awscliv2.zip" \
    ;

RUN set -x \
    && ./aws/install \
    && /usr/local/bin/aws --version \
    && rm -rf "awscliv2.zip" \
    && rm -rf "./aws" \
    ;

RUN set -x \
    && useradd -ms /bin/bash ansible_user

USER ansible_user
WORKDIR /home/ansible_user

FROM base AS ansible

RUN set -x \ 
    && pip install --upgrade pip \
    && pip install --user ansible \
    && pip install --user boto3 \
    ;

# remove netbox collection, contains vulnerabilities and is unused.
RUN rm -rf ~/.local/lib/python3.9/site-packages/ansible_collections/netbox/
# Install Packer
USER root

RUN set -x \
    && curl "https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip" -o "packer.zip" \
    && unzip packer.zip \
    && chmod +x packer \
    && mv packer /usr/local/bin \
    && rm -vf packer.zip \
    ;

USER ansible_user
ENTRYPOINT ["/bin/bash"]
