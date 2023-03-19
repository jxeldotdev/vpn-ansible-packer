FROM python:3.11-buster AS base

RUN set -x \
    && apt-mark hold git \
    && apt-mark hold git-man \
    ; 

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
        sudo \
        jq \
        ;

RUN set -x \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
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
    && pip install --upgrade pip \
    && pip install ansible \
    && pip install boto3 \
    ;

# remove netbox collection, contains vulnerabilities and is unused.
RUN rm -rf ~/.local/lib/python3.11/site-packages/ansible_collections/netbox/

RUN set -x \
    && curl "https://releases.hashicorp.com/packer/1.8.6/packer_1.8.6_linux_amd64.zip" -o "packer.zip" \
    && unzip packer.zip \
    && chmod +x packer \
    && mv packer /usr/local/bin \
    && rm -vf packer.zip \
    ;

ENTRYPOINT ["/bin/bash"]
