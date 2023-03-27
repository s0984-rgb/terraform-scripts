# Note: You can use any Debian/Ubuntu based image you want. 
FROM rockylinux:9.1
ARG USER

# Prerequisites
RUN dnf install -y git which yum-utils

# Terraform
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN dnf install -y terraform

# Terraform docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
RUN tar -xzf terraform-docs.tar.gz
RUN chmod +x terraform-docs
RUN mv terraform-docs /usr/local/bin/terraform-docs
RUN rm -rf terraform-docs.tar.gz

RUN adduser --shell /bin/bash --uid 1000 ${USER}
COPY --chown=${USER}:${USER} ./.bashrc /home/${USER}/
RUN curl -sfL https://direnv.net/install.sh | bash
RUN terraform-docs completion bash > ~/.terraform-docs-completion
USER ${USER}