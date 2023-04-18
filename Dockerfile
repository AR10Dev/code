FROM ubuntu:rolling

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    sudo \
    gnupg \
    git \
    curl \
    wget \
    build-essential \
    nala \
    bat \
    unzip \
    fontconfig \
    exa \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Add FiraCode Font
RUN curl --fail --location --show-error "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" -o FiraCode.zip \
    && unzip -o -q -d ./FiraCode FiraCode.zip \
    && mv ./FiraCode/*.ttf /usr/share/fonts/ \
    && rm -r -d ./FiraCode FiraCode.zip \
    && fc-cache -f

# Add RTX
RUN wget -qO - https://rtx.pub/gpg-key.pub | gpg --dearmor | tee /usr/share/keyrings/rtx-archive-keyring.gpg 1> /dev/null \
    && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/rtx-archive-keyring.gpg] https://rtx.pub/deb stable main" | tee /etc/apt/sources.list.d/rtx.list \
    && apt update \
    && apt install -y rtx

# Add VSCode
RUN wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/vscode-archive-keyring.gpg 1> /dev/null \
    && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscode-archive-keyring.gpg ] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list \
    && apt update \
    && apt install -y code
    
# Add Startship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y \
    && mkdir -p ~/.config

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

# Configure Zsh and add Starship config
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY .dotfiles/ /home/$USERNAME/.dotfiles/

RUN sudo /home/$USERNAME/.dotfiles/install.sh

CMD [ "code", "tunnel", "--accept-server-license-terms" ]
