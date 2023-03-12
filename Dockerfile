FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    sudo \
    gnupg \
    git \
    curl \
    wget \
    nala \
    bat \
    unzip \
    fontconfig \
    exa \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Configure Zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Add FiraCode Font
RUN curl --fail --location --show-error "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" -o FiraCode.zip \
    && unzip -o -q -d ./FiraCode FiraCode.zip \
    && mv ./FiraCode/*.ttf /usr/share/fonts/ \
    && rm -r -d ./FiraCode FiraCode.zip \
    && fc-cache -f

# Add Startship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y \
    && echo 'eval "$(starship init zsh)"' >> ~/.zshrc \
    && mkdir -p ~/.config

COPY starship.toml ~/.config/

# Add RTX
RUN wget -qO - https://rtx.pub/gpg-key.pub | gpg --dearmor | tee /usr/share/keyrings/rtx-archive-keyring.gpg 1> /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/rtx-archive-keyring.gpg arch=arm64] https://rtx.pub/deb stable main" | tee /etc/apt/sources.list.d/rtx.list \
    && apt update \
    && apt install -y rtx

# Add VSCode
RUN curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64" \
    --output /tmp/vscode-cli.tar.gz \
    && tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin \
    && rm /tmp/vscode-cli.tar.gz

# Creating a non-root user
ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME

CMD [ "code", "tunnel", "--accept-server-license-terms" ]
