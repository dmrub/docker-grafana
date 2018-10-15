#!/bin/bash

set -xe

export GF_PATHS_CONFIG=${GF_PATHS_CONFIG:-/etc/grafana/grafana.ini}
export GF_PATHS_DATA=${GF_PATHS_DATA:-/var/lib/grafana}
export GF_PATHS_HOME=${GF_PATHS_HOME:-/usr/share/grafana}
export GF_PATHS_LOGS=${GF_PATHS_LOGS:-/var/log/grafana}
export GF_PATHS_PLUGINS=${GF_PATHS_PLUGINS:-/var/lib/grafana/plugins}
export GF_PATHS_PROVISIONING=${GF_PATHS_PROVISIONING:-/etc/grafana/provisioning}

CONFIG_DIR=$(dirname "$GF_PATHS_CONFIG")

mkdir -p "$CONFIG_DIR"
mkdir -p "$GF_PATHS_DATA"
mkdir -p "$GF_PATHS_HOME"

chown -R root:root "$CONFIG_DIR"
chmod -R a+r "$CONFIG_DIR"
chown -R grafana:grafana "$GF_PATHS_DATA"
chown -R grafana:grafana "$GF_PATHS_HOME"

mkdir -p "$GF_PATHS_HOME/.aws" && \
    groupadd -r -g $GF_GID grafana && \
    useradd -r -u $GF_UID -g grafana grafana && \
    mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_LOGS" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_DATA" && \
    cp "$GF_PATHS_HOME/conf/sample.ini" "$GF_PATHS_CONFIG" && \
    cp "$GF_PATHS_HOME/conf/ldap.toml" /etc/grafana/ldap.toml && \
    chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" && \
    chmod 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS"

exec gosu grafana /run.sh
