FROM node:22-bookworm

# System dependencies for native modules and development tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    jq \
    sudo \
    openssh-client \
    ca-certificates \
    gnupg \
    libpam-dev \
    libvips-dev \
    libsecret-1-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    libpixman-1-dev \
    pkg-config \
    procps \
    htop \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Enable corepack for pnpm
RUN corepack enable && corepack prepare pnpm@10.23.0 --activate

# Create non-root user for Daytona
ARG USERNAME=daytona
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if getent group $USER_GID > /dev/null 2>&1; then \
      groupmod -n $USERNAME $(getent group $USER_GID | cut -d: -f1); \
    else \
      groupadd --gid $USER_GID $USERNAME; \
    fi \
    && if id -u $USER_UID > /dev/null 2>&1; then \
      EXISTING_USER=$(getent passwd $USER_UID | cut -d: -f1); \
      usermod -l $USERNAME -d /home/$USERNAME -m $EXISTING_USER; \
    else \
      useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install Bun for the daytona user
USER $USERNAME
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/$USERNAME/.bun/bin:${PATH}"

# Set default shell
ENV SHELL=/bin/bash

WORKDIR /home/$USERNAME/openclaw
