# NEO private network - Dockerfile
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Disable dotnet usage information collection
# https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry#behavior
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    unzip \
    screen \
    expect \
    libleveldb-dev \
    git-core \
    wget \
    curl \
    libssl-dev \
    apt-transport-https

#RUN apt-get update && apt-get install -y apt-transport-https

# Setup microsoft repositories
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*


# neo setup: clone and install dependencies
RUN git clone https://github.com/cronfoundation/Node-cli-of-the-Cronium-blockchain-4.0 /neo-cli-src

WORKDIR /neo-cli-src
RUN dotnet restore
RUN dotnet publish -c Release -o /neo-cli

# Plugin setup build from source
RUN git clone https://github.com/cronfoundation/Plugins-of-the-Cronium-blockchain-4.0.git /cron-plugins

# remove unwanted plugins
# RUN rm -rf /cron-plugins/SimplePolicy.UnitTests
# RUN rm -rf /cron-plugins/ApplicationLogs
# RUN rm -rf /cron-plugins/ImportBlocks
# RUN rm -rf /cron-plugins/RpcSecurity
# RUN rm -rf /cron-plugins/StatesDumper

# SimplePolicy plugin build
WORKDIR /cron-plugins/SimplePolicy
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# ImportBlocks plugin build
WORKDIR /cron-plugins/ImportBlocks
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# RpcSecurity plugin build
WORKDIR /cron-plugins/RpcSecurity
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# CoreMetrics plugin build
WORKDIR /cron-plugins/CoreMetrics
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# ApplicationLogs plugin build
WORKDIR /cron-plugins/ApplicationLogs
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# RpcWallet plugin build
WORKDIR /cron-plugins/RpcWallet
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

# RpcNep5Tracker plugin build
WORKDIR /cron-plugins/RpcNep5Tracker
#RUN dotnet restore
RUN dotnet build --framework netstandard2.0 -o /neo-cli/Plugins

WORKDIR /neo-cli

# Copy config files
COPY ./config/config.json /neo-cli/config.json
COPY ./config/protocol.json /neo-cli/protocol.json

# Copy wallet
# COPY ./config/wallet.json /neo-cli/wallet.json

# Copy scripts
COPY ./scripts/start_consensus_node.sh /neo-cli
COPY ./scripts/entrypoint.sh /neo-cli

# Change scripts permissions
RUN chmod +x /neo-cli/entrypoint.sh
RUN chmod +x /neo-cli/start_consensus_node.sh

# Run entrypoint script
ENTRYPOINT ["/neo-cli/entrypoint.sh" ]
