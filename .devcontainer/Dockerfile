FROM python:alpine
ARG USER

# Install ansible
RUN python3 -m pip install --upgrade pip ansible

# Terraform
COPY --from=hashicorp/terraform:latest /bin/terraform /bin/terraform

# Terraform docs
COPY --from=quay.io/terraform-docs/terraform-docs:latest /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

# Add base packages
RUN apk add --no-cache bash curl openssl openssh git perl direnv nomad util-linux gnupg 

# Create custom user
RUN adduser -s /bin/bash -u 1000 -D ${USER}
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

ENTRYPOINT [ "sleep", "infinity" ]
