FROM ubuntu:rolling

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y \
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
    zsh \
    locales \
    && rm -rf /var/lib/apt/lists/* 

# Add Locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Add FiraCode Font
RUN curl --fail --location --show-error "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" -o FiraCode.zip \
    && unzip -o -q -d ./FiraCode FiraCode.zip \
    && mv ./FiraCode/*.ttf /usr/share/fonts/ \
    && rm -r -d ./FiraCode FiraCode.zip \
    && fc-cache -f

# Add RTX
RUN wget -qO - https://rtx.pub/gpg-key.pub | gpg --dearmor | tee /usr/share/keyrings/rtx-archive-keyring.gpg 1> /dev/null \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/usr/share/keyrings/rtx-archive-keyring.gpg] https://rtx.pub/deb stable main" | tee /etc/apt/sources.list.d/rtx.list \
    && apt update \
    && apt install -y rtx

# Add VSCode
RUN wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/vscode-archive-keyring.gpg 1> /dev/null \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list \
    && apt update \
    && apt install -y code \
    && apt-get clean
    
# Add Startship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Creating a non-root user
ARG USERNAME=code
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

COPY --chown=$USER_UID:$USER_GID .dotfiles/ /home/$USERNAME/.dotfiles/

RUN chmod u+x /home/$USERNAME/.dotfiles/install.sh

# Set the default user
USER $USERNAME

WORKDIR /home/$USERNAME/

RUN mkdir .vscode-data

ENV VSCODE_CLI_DATA_DIR /home/$USERNAME/.vscode-data

# Install Oh My Zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD [ "code", "tunnel", "--accept-server-license-terms", "--disable-telemetry" ]
