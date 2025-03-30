FROM php:8.2-apache AS builder

SHELL ["/bin/bash", "-c"]

ENV LANG=C.UTF-8
ENV TZ=America/Cuiaba
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/home/coder/.composer
ENV COMPOSER_CACHE_DIR=/home/coder/.composer/cache
ENV COMPOSER_NO_INTERACTION=1

# Instalação de dependências em uma única camada
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get update && apt upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    locales \
    lsb-release \
    nano \
    unzip \
    git \
    nodejs \
    npm \
    openssh-client \
    sudo \
    libzip-dev \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Criação do usuário
ARG USERNAME=coder
ARG USER_UID=1001
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --shell /bin/bash --create-home ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}\
    && mkdir -p /home/${USERNAME}/.composer/cache \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.composer \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Instalação do Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && EXPECTED_SIGNATURE=$(curl -sS https://composer.github.io/installer.sig) \
    && ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');") \
    && if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then \
      echo "ERROR: Invalid installer signature"; \
      rm composer-setup.php; \
      exit 1; \
    fi \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Se necessário, instale extensões do PHP aqui (opcional)
# RUN apt-get update && apt-get install -y --no-install-recommends ... && docker-php-ext-install ...
RUN docker-php-ext-install mysqli pdo_mysql pdo_pgsql pcntl

USER coder
WORKDIR /home/coder/app
EXPOSE 8000

# docker build --no-cache -t coderphp:8.2 -f Dockerfile .