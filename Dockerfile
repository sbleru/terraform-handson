# ベースイメージとしてUbuntuを使用
FROM ubuntu:20.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive

# シェルオプションを設定
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 必要なパッケージをインストール
# https://packages.ubuntu.com/ または `apt-cache policy <target>` でバージョン確認
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl=7.68.0-1ubuntu2.22 \
    gnupg=2.2.19-3ubuntu2.2 \
    apt-transport-https=2.0.10 \
    ca-certificates=20230311ubuntu0.20.04.1 \
    lsb-release=11.1.0ubuntu2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Google Cloud SDKリポジトリを追加
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Google Cloud SDKをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    google-cloud-sdk=467.0.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Terraformのリポジトリを追加
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && DEBIAN_CODENAME=$(lsb_release -cs) \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${DEBIAN_CODENAME} main" | tee /etc/apt/sources.list.d/hashicorp.list

# Terraformをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    terraform=1.9.2-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /workspace

# コンテナ内でのデフォルトコマンド
CMD ["bash"]