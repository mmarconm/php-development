FROM php:8.2-apache

# SHELL ["/bin/bash", "-xo", "pipefail", "-c"]
SHELL ["/bin/bash", "-c"]

ENV LANG=C.UTF-8
ENV TZ=America/Cuiaba
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/home/coder/.composer
ENV COMPOSER_CACHE_DIR=/home/coder/.composer/cache
ENV COMPOSER_NO_INTERACTION=1

# Install dependencies
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \ 
    && echo $TZ > /etc/timezone \ 
    && apt-get update \
    && apt upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    locales \
    lsb-release \
    nano \
    unzip \
    nodejs \
    npm \
    openssh-client \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# CREATE USER
ARG USERNAME=coder
ARG USER_UID=1001
ARG USER_GID=${USER_UID}
RUN apt-get update \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --shell /bin/bash --create-home ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# COMPOSER INSTALL
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && EXPECTED_SIGNATURE="$(curl -fsSL https://composer.github.io/installer.sig)" \
    && ACTUAL_SIGNATURE="$(php -r \"echo hash_file('sha384', 'composer-setup.php');\")" \
    && if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then echo 'ERROR: Invalid installer signature'; rm composer-setup.php; exit 1; fi \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
    
# INSTALL PHP EXTENSIONS
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#     libzip-dev \
#     libpng-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     libxml2-dev \
#     libicu-dev \
#     libxslt1-dev \
#     libonig-dev \
#     libpq-dev \
#     libmcrypt-dev \
#     libldap2-dev \
#     libbz2-dev \
#     libcurl4-openssl-dev \
#     libssl-dev \
#     zlib1g-dev \
#     && docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql mysqli xsl intl ldap bz2 curl soap exif bcmath opcache

EXPOSE 8000
USER coder
WORKDIR /home/coder

# docker build --no-cache -t codephp:8.3 -f Dockerfile .