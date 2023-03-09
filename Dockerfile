FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y \
    git \
    curl \
    wget \
    nala \
    bat \
    fc-cache \
    unzip \
    exa \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Configure Zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Add FiraCode Font
RUN curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" \
	  && unzip FiraCode.zip \
	  && mv *.ttf /usr/share/fonts/ \
	  && fc-cache -fv

# Add Startship
RUN curl -sS https://starship.rs/install.sh | sh \
	  && echo 'eval "$(starship init zsh)"' >> ~/.zshrc \
	  && mkdir -p ~/.config

COPY starship.toml ~/.config/

# Add RTX
RUN wget -qO - [https://rtx.pub/gpg-key.pub](https://rtx.pub/gpg-key.pub) | gpg --dearmor | sudo tee /usr/share/keyrings/rtx-archive-keyring.gpg 1> /dev/null \
	  && echo "deb [signed-by=/usr/share/keyrings/rtx-archive-keyring.gpg arch=arm64] [https://rtx.pub/deb](https://rtx.pub/deb) stable main" | sudo tee /etc/apt/sources.list.d/rtx.list \
	  && sudo apt update \
	  && sudo apt install -y rtx

# Add VSCode
RUN curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64" \
    --output /tmp/vscode-cli.tar.gz \
    && tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin \
    && rm /tmp/vscode-cli.tar.gz

# Set user and group
ARG user=code
ARG group=code
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user}

# Switch to user
USER ${uid}:${gid}

CMD [ "code", "tunnel", "--accept-server-license-terms" ]
