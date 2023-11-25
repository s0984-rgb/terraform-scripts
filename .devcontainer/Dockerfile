FROM python:bullseye
ARG DC_USER

# Install ansible
RUN python3 -m pip install --upgrade pip ansible

# Terraform
COPY --from=hashicorp/terraform:latest /bin/terraform /bin/terraform

# Terraform docs
COPY --from=quay.io/terraform-docs/terraform-docs:latest /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

# Nomad
COPY --from=hashicorp/nomad:1.6.1 /bin/nomad /bin/nomad

# Consul
COPY --from=hashicorp/consul:1.16.1 /bin/consul /bin/consul

# Vault
COPY --from=hashicorp/vault:1.14.1 /bin/vault /bin/vault

# Add base packages
RUN apt update -y && apt install -y bash curl openssl openssh-client git perl direnv util-linux gnupg netcat bash-completion jq bsdmainutils gettext-base
RUN apt clean autoremove

# Create custom user
RUN useradd -s /bin/bash -u 1000 -m ${DC_USER}
RUN rm -f /home/${DC_USER}/.bashrc && ln -s /terraform/.devcontainer/.bashrc /home/${DC_USER}/.bashrc
RUN rm -f /home/${DC_USER}/.profile && ln -s /terraform/.devcontainer/.profile /home/${DC_USER}/.profile

# Create volume folders
RUN mkdir -p /home/${DC_USER}/.vscode-server/extensions \
  /home/${DC_USER}/.vscode-server-insiders/extensions \
  /home/${DC_USER}/.bash_history
# Set ownership for container user
RUN chown -R ${DC_USER}:${DC_USER} \
  /home/${DC_USER}

USER ${DC_USER}

# Install and configure fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/${DC_USER}/.fzf \
  && /home/${DC_USER}/.fzf/install --all --no-update-rc
