FROM quay.io/roboll/helmfile:v0.142.0

# -----------------------------------------------------------------------------

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Get helm/helmfile binaries and plugins from robol docker image
COPY --from=0 /usr/local/bin/* /usr/local/bin/
COPY --from=0 /root/.local/share/helm/plugins/ /root/.local/share/helm/plugins/

# Add source scripts
COPY . /opt/ci/

RUN apt update -y \
    && apt install -y git curl vim python3 python3-pip \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \ 
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt update -y \
    && apt install google-cloud-sdk -y \
    && pip install -r /opt/ci/requirements.txt \
    && mkdir ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10