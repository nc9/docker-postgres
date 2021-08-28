ARG DISTRO=debian
ARG IMAGE_VERSION=bullseye
ARG IMAGE_VARIANT=slim

FROM $DISTRO:$IMAGE_VERSION-$IMAGE_VARIANT AS postgres-base
LABEL maintainer="Nik Cubrilovic <nik@nikcub.me>"


# Reset ARG for version
ARG IMAGE_VERSION

RUN apt-get -qq update --fix-missing && apt-get -qq --yes upgrade

# Setup deps
RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    locales gnupg2 wget ca-certificates rpl pwgen software-properties-common  iputils-ping \
    apt-transport-https curl gettext

# Setup postgres source
ARG IMAGE_VERSION=bullseye
RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && sh -c "echo \"deb http://apt.postgresql.org/pub/repos/apt/ ${IMAGE_VERSION}-pgdg main\" > /etc/apt/sources.list.d/pgdg.list" \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | apt-key add - \
    && apt-get -y --purge autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && dpkg-divert --local --rename --add /sbin/initctl

# Install postgres versions
ARG PG_VERSIONS="13 12"
ARG POSTGIS_VERSION="3"
RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    &&  apt-get update \
    && for pg in ${PG_VERSIONS}; do \
    apt-get install -y postgresql-${pg} postgresql-server-dev-${pg} postgresql-server-${pg}-postgis-${POSTGIS_VERSION} || exit 1; \
    done

# Install other deps
ENV ADDITIONAL_PACKAGES="lsb-release git sudo wget jq vim"
RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${ADDITIONAL_PACKAGES}\
    && apt-get -y --purge autoremove \
    && apt-get clean

RUN ["bash"]