FROM openjdk:8u181-jre-slim-stretch

LABEL maintainer="Sunghoon Kang <me@devholic.io>"

WORKDIR /opt

RUN apt-get update && apt-get install -y \
    wget \
    procps \
    bash-completion

RUN echo ". /etc/bash_completion" >> ~/.bashrc

# halyard
ARG HALYARD_VERSION

RUN wget -qO- \
    https://spinnaker-artifacts.storage.googleapis.com/halyard/${HALYARD_VERSION}/debian/halyard.tar.gz | tar x && \
    mv /opt/hal /usr/local/bin && \
    chmod +x /usr/local/bin/hal && \
    mkdir -p /var/log/spinnaker/halyard && \
    mkdir -p /etc/bash_completion.d && \
    hal > /dev/null && \
    hal --print-bash-completion | tee /etc/bash_completion.d/hal > /dev/null && \
    echo ". /etc/bash_completion.d/hal" >> ~/.bashrc

# kubectl
ARG KUBECTL_VERSION

RUN wget -qO /usr/local/bin/kubectl https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null && \
    echo ". /etc/bash_completion.d/kubectl" >> ~/.bashrc

WORKDIR /tie

CMD ["bash"]
