FROM python:bullseye
ARG USER

# Install ansible
RUN python3 -m pip install --upgrade pip ansible

# Terraform
COPY --from=hashicorp/terraform:latest /bin/terraform /bin/terraform

# Terraform docs
COPY --from=quay.io/terraform-docs/terraform-docs:latest /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

# Nomad
COPY --from=hashicorp/nomad:1.6.1 /bin/nomad /bin/nomad

# Add base packages
RUN apt update -y && apt install -y bash curl openssl openssh-client git perl direnv util-linux gnupg netcat bash-completion jq
RUN apt clean autoremove

# Create custom user
RUN useradd -s /bin/bash -u 1000 -m ${USER}
COPY --chown=${USER}:${USER} ./.bashrc /home/${USER}/
COPY --chown=${USER}:${USER} ./.profile /home/${USER}/

# Create VSCode folder
RUN mkdir -p /home/${USER}/.vscode-server/extensions \
  /home/${USER}/.vscode-server-insiders/extensions
RUN chown -R ${USER} \
  /home/${USER}/.vscode-server \
  /home/${USER}/.vscode-server-insiders

USER ${USER}

# Install and configure fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/${USER}/.fzf \
  && /home/${USER}/.fzf/install --all
