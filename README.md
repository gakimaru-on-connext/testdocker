<!-- omit in toc -->
# Docker Test

[https://github.com/gakimaru-on-connext/testansible](https://github.com/gakimaru-on-connext/testansible)

---
- [■概要](#概要)
- [■動作要件](#動作要件)
- [■VM 操作方法](#vm-操作方法)
- [■セットアップ内容](#セットアップ内容)
- [■各サーバーへのアクセス方法](#各サーバーへのアクセス方法)
- [■解説：Vagrant 設定](#解説vagrant-設定)
- [■解説：プロビジョニング](#解説プロビジョニング)
- [■Docker 操作方法](#docker-操作方法)
- [■Docker Compose 操作方法](#docker-compose-操作方法)
- [■シェルスクリプトによる Docker プロビジョニングを行う場合](#シェルスクリプトによる-docker-プロビジョニングを行う場合)
- [■Ansible による Docker プロビジョニングを行う場合](#ansible-による-docker-プロビジョニングを行う場合)
- [■セキュアな Docker 操作方法](#セキュアな-docker-操作方法)
- [■ディレクトリ構成](#ディレクトリ構成)

---
## ■概要

- Vagrant を用いた VM 上へのOSセットアップのテスト
- OS 以外のパッケージは Docker（Docker Compose） で扱う
  - Docker を単独で利用するよりも、Docker Compose を利用する方がシンプルに構成できる
- シェル（スクリプト）または Ansible によるセットアップと比較するためのリポジトリも用意
  - シェルスクリプト：[https://github.com/gakimaru-on-connext/testvagrant](https://github.com/gakimaru-on-connext/testvagrant)
  - Ansible：[https://github.com/gakimaru-on-connext/testansible](https://github.com/gakimaru-on-connext/testansible)

---
## ■動作要件

- macOS ※x86系のみ

- Oracle Virtualbox

  - https://www.oracle.com/jp/virtualization/technologies/vm/downloads/virtualbox-downloads.html

- Vagrant

  ```shell
  $ brew install vagrant
  ```

- （必須ではない）Docker クライアント用コマンドラインツール

  ```shell
  $ brew install docker
  ```

  - 注）cask ではないので注意
    - brew install --cask docker としてしまうと、コマンドラインツールではなく、GUI ツールの Docker Engine をインストールしてしまうので注意
  - macOS 上から Docker を操作したい場合に必要

---
## ■VM 操作方法

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#vm-%E6%93%8D%E4%BD%9C%E6%96%B9%E6%B3%95) 参照

---
## ■セットアップ内容

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E5%86%85%E5%AE%B9) とほぼ同じ
- OS は Rocky Linux 9 もしくは Ubuntu 22.04
  - コミットしている状態では Ubuntu 22.04

---
## ■各サーバーへのアクセス方法

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E5%90%84%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%B8%E3%81%AE%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E6%96%B9%E6%B3%95) 参照

<!-- omit in toc -->
### ▼Adminer

<!-- omit in toc -->
#### ▽接続

- Webブラウザから http://192.168.56.10:8080 にアクセス
- 各種DBシステムを操作するサーバーシステム
- MariaDB に接続する場合：
  - データベース種類：MySQL
  - サーバ：rdb1
  - ユーザ名：admin
  - パスワード：hogehoge
  - データベース：mysql
- PostgreSQL に接続する場合：
  - データベース種類：PostgreSQL
  - サーバ：rdb2
  - ユーザ名：admin
  - パスワード：hogehoge
  - データベース：postgres
- MongoDB に接続する場合：
  - ※接続不可
  - データベース種類：MongoDB
  - サーバ：ddb
  - ユーザ名：
  - パスワード：
  - データベース：

---
## ■解説：Vagrant 設定

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E8%A7%A3%E8%AA%ACvagrant-%E8%A8%AD%E5%AE%9A) 参照

---
## ■解説：プロビジョニング

<!-- omit in toc -->
### ▼Vagrant 設定

- Vagrantfile

  - プラグインインストール設定：Docker Compose 操作

    ```ruby
    install_plugin('vagrant-docker-compose')
    ```

  - OSイメージ設定：ubuntu22.04

    ```ruby
    config.vm.box = "generic/ubuntu2204"
    ```

    - "generic/rocky9" では、Vagrant による Docker のインストールに対応していなかったため ubuntu2204 を使用
    - シェルスクリプトやAnsibleによるセットアップに切り替える場合は、"generic/rocky9" に変更する必要あり

  - Docker 関係ファイルの共有設定

    ```ruby
    config.vm.synced_folder "../docker", "/vagrant/docker", type: "rsync"
    ```

  - プロビジョニング設定：Docker のインストール

    ```ruby
    config.vm.provision :docker
    ```

    - docker プロビジョナーは、本来は Docker の操作を行うプロビジョナーだが、ここでは Docker のインストールにしか使用しないため、設定内容は空で良い

  - プロビジョニング設定：Docker Compose の実行

    ```ruby
    config.vm.provision :docker_compose, yml: "/vagrant/docker/docker-compose.yml", run: "always"
    ```

    - run: "always" を指定し、2回目以降の Vagrant の起動でも、毎回 Docker Compose が実行されるようにする

<!-- omit in toc -->
### ▼Docker Compose 設定

- docker/docker-compose.yml に各コンテナの設定を記述
- 非常にシンプルな構成としており、コンテナビルド用の Dockerfile を使用せず（コンテナをビルドせず）、公開されているコンテナイメージをそのまま利用する

<!-- omit in toc -->
#### ▽永続化

- volumes 設定を使用し、DBデータなどはコンテナホスト側（macOS から見たらゲストの Vagrant VM）のディレクトリをマウントするように設定
  - これにより、コンテナを破棄してもデータが消えない
  - Vagrant VM を破棄するとデータが消える

- コンテナホスト側（Vagrant VM 側）のディレクトリ構成

  ```shell
  /opt/
  ├── cache/          # cache コンテナ用
  │   └── redis/      # Redis 用
  │       └── data/
  ├── ddb/            # ddb コンテナ用
  │   └── mongodb/    # MongoDB 用
  │       └── data/
  ├── rdb1/           # rdb1 コンテナ用
  │   └── mariadb/    # MariaDB 用
  │       └── data/
  ├── rdb2/           # rdb2 コンテナ用
  │   └── postgresql/ # PostgreSQL 用
  │       └── data/
  └── web/            # web コンテナ用 
      └── nginx/      # nginx 用
          └── (なし)
  ```

<!-- omit in toc -->
#### ▽ログ

- volumes 設定を使用し、ログはコンテナホスト側（macOS から見たらゲストの Vagrant VM）のディレクトリをマウントするように設定

- コンテナホスト側（Vagrant VM 側）のディレクトリ構成

  ```shell
  /opt/
  ├── cache/          # cache コンテナ用
  │   └── redis/      # Redis 用
  │       └── (なし)
  ├── ddb/            # ddb コンテナ用
  │   └── mongodb/    # MongoDB 用
  │       └── log/
  ├── rdb1/           # rdb1 コンテナ用
  │   └── mariadb/    # MariaDB 用
  │       └── log/
  ├── rdb2/           # rdb2 コンテナ用
  │   └── postgresql/ # PostgreSQL 用
  │       └── log/
  └── web/            # web コンテナ用 
      └── nginx/      # nginx 用
          └── log/
  ```

  - ただし、所定の場所にログが出力されていないのか、nginx 以外の記録を確認できていない

---
## ■Docker 操作方法

<!-- omit in toc -->
### ▼docker コマンドの実行方法１：VM にログインして docker コマンドを実行

<!-- omit in toc -->
#### ▽準備

- 不要

<!-- omit in toc -->
#### ▽コマンド実行

- macOS

  ```shell
  # VM にログイン
  $ cd vagrant
  $ vagrant ssh
  ```

- VM

  ```shell
  # docker コマンドを実行（何かしらのサブコマンドを指定すると、Docker サーバーにアクセスする）
  $ docker version
  Client: Docker Engine - Community
  Version:           20.10.17
  API version:       1.41
  ...
  OS/Arch:          linux/amd64
  ...

  Server: Docker Engine - Community
  Engine:
    Version:          20.10.17
    API version:      1.41 (minimum version 1.12)
    ...
    OS/Arch:          linux/amd64
    ...
  ```

<!-- omit in toc -->
### ▼docker コマンドの実行方法2：macOS から　docker コマンドを実行

<!-- omit in toc -->
#### ▽準備

- macOS

  ```shell
  # VM にログイン
  $ cd vagrant
  $ vagrant ssh
  ```

- VM

  ```shell
  # /usr/lib/systemd/system/docker.service をテキストエディタで編集
  $ cd /usr/lib/systemd/system
  $ sudo vi docker.service  または  $ sudo nano docker.service
  # この行を変更
  ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
  # ↓ コマンドラインオプションに「--tls=false -H tcp://0.0.0.0:2375」を追加
  ExecStart=/usr/bin/dockerd -H fd:// --tls=false -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock
  # サービス設定を再読み込み
  $ sudo systemctl daemon-reload
  # Docker サービスを再起動
  $ sudo systemctl restart docker
  ```

<!-- omit in toc -->
#### ▽コマンド実行

- macOS

  ```shell
  # docker コマンドの接続先を環境変数で設定
  $ export DOCKER_HOST=tcp://192.168.56.10:2375
  $ export DOCKER_MACHINE_NAME=testdocker
  $ unset DOCKER_TLS_VERIFY
  $ unset DOCKER_CERT_PATH
  # docker コマンドを実行（何かしらのサブコマンドを指定すると、Docker サーバーにアクセスする）
  $ docker version
  Client: Docker Engine - Community
  Version:           20.10.17
  API version:       1.41
  ...
  OS/Arch:           darwin/amd64
  ...

  Server: Docker Engine - Community
  Engine:
    Version:          20.10.17
    API version:      1.41 (minimum version 1.12)
    ...
    OS/Arch:          linux/amd64
    ...
  ```

  - macOS 上から頻繁に docker コマンドを使用する場合は、これらの環境変数を ~/.zshrc に設定しておくなと便利

<!-- omit in toc -->
### ▼docker コンテナにログイン

- docker コマンドの exec サブコマンドを、-it オプションを付けて bash を実行することでリモートログインを実現する

  ```shell
  $ docker exec -it (コンテナ名) bash
  ```

  - -i ... interactive: 標準入力（キー操作）を受け付ける
  - -t ... tty: 疑似 TTY を割り当て（端末操作を可能にする）

<!-- omit in toc -->
#### ▽rdb1 (MariaDB) コンテナにログイン

```shell
$ docker exec -it rdb1 bash
```

<!-- omit in toc -->
#### ▽rdb2 (PostgreSQL) コンテナにログイン

```shell
$ docker exec -it rdb2 bash
```

<!-- omit in toc -->
#### ▽ddb (MongoDB) コンテナにログイン

```shell
$ docker exec -it ddb bash
```

<!-- omit in toc -->
#### ▽cache (Redis) コンテナにログイン

```shell
$ docker exec -it cache bash
```

<!-- omit in toc -->
#### ▽web (Nginx) コンテナにログイン

```shell
$ docker exec -it web bash
```


<!-- omit in toc -->
### ▼docker コンテナの確認

<!-- omit in toc -->
#### ▽稼働中のコンテナのリストアップ

```shell
$ docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED       STATUS         PORTS                                      NAMES
285e17f606ab   nginx:latest            "/docker-entrypoint.…"   3 hours ago   Up 2 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   web
9a888f6d8ce9   adminer:latest          "entrypoint.sh docke…"   3 hours ago   Up 3 minutes   0.0.0.0:8080->8080/tcp                     adminer
02c7153223f9   mariadb/server:latest   "docker-entrypoint.s…"   3 hours ago   Up 2 minutes   0.0.0.0:3306->3306/tcp                     rdb1
7c94e5e9a5a1   redis:latest            "docker-entrypoint.s…"   3 hours ago   Up 2 minutes   0.0.0.0:6379->6379/tcp                     cache
ec473add1fe7   postgres:latest         "docker-entrypoint.s…"   3 hours ago   Up 2 minutes   0.0.0.0:5432->5432/tcp                     rdb2
e70b1563b997   mongo:latest            "docker-entrypoint.s…"   3 hours ago   Up 2 minutes   0.0.0.0:27017->27017/tcp                   ddb
```

<!-- omit in toc -->
### ▼docker コンテナの停止（kill）

```shell
$ docker kill (コンテナ名|コンテナID)
```

<!-- omit in toc -->
#### ▽停止しているコンテナのリストアップ

```shell
$ docker ps -a
CONTAINER ID   IMAGE                   COMMAND                  CREATED       STATUS                            PORTS                      NAMES
285e17f606ab   nginx:latest            "/docker-entrypoint.…"   3 hours ago   Exited (137) 2 minutes ago                                   web
9a888f6d8ce9   adminer:latest          "entrypoint.sh docke…"   3 hours ago   Exited (137) About a minute ago                              adminer
02c7153223f9   mariadb/server:latest   "docker-entrypoint.s…"   3 hours ago   Up 5 minutes                      0.0.0.0:3306->3306/tcp     rdb1
7c94e5e9a5a1   redis:latest            "docker-entrypoint.s…"   3 hours ago   Up 5 minutes                      0.0.0.0:6379->6379/tcp     cache
ec473add1fe7   postgres:latest         "docker-entrypoint.s…"   3 hours ago   Up 5 minutes                      0.0.0.0:5432->5432/tcp     rdb2
e70b1563b997   mongo:latest            "docker-entrypoint.s…"   3 hours ago   Up 5 minutes                      0.0.0.0:27017->27017/tcp   ddb
```

- コンテナのプログラム終了または docker kill によって終了したコンテナは、STATUS が Exited として表示される
- -a オプションは稼働中のコンテナと終了したコンテナを全て出力する

<!-- omit in toc -->
### ▼docker コンテナの破棄

```shell
$ docker rm (コンテナ名|コンテナID)
```

- 停止状態のコンテナを破棄できる

<!-- omit in toc -->
### ▼docker コンテナイメージのリストアップ

```shell
$ docker image ls
REPOSITORY       TAG       IMAGE ID       CREATED         SIZE
mongo            latest    d34d21a9eb5b   4 days ago      693MB
postgres         latest    b37c2a6c1506   13 days ago     376MB
redis            latest    dc7b40a0b05d   13 days ago     117MB
nginx            latest    2b7d6430f78d   2 weeks ago     142MB
adminer          latest    75cd6c93316c   3 weeks ago     90.7MB
mariadb/server   latest    763362775627   16 months ago   362MB
```

<!-- omit in toc -->
### ▼docker コンテナイメージの破棄

```shell
$ docker image rm (コンテナイメージID)
```

- 未使用状態のコンテナイメージを破棄できる

---
## ■Docker Compose 操作方法

<!-- omit in toc -->
### ▼docker-compose コマンドの実行方法：VM にログインして docker-compose コマンドを実行

- macOS

  ```shell
  # VM にログイン
  $ cd vagrant
  $ vagrant ssh
  ```

- VM

  ```shell
  # docker-compose.yml が存在するディレクトリに移動
  cd /vagrant/docker/
  # docker-compose コマンドを実行（何かしらのサブコマンドを指定すると、Docker サーバーにアクセスする）
  $ docker-compose ps
   Name                Command               State               Ports
  --------------------------------------------------------------------------------
  adminer   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
  cache     docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
  ddb       docker-entrypoint.sh mongod      Up      0.0.0.0:27017->27017/tcp
  rdb1      docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp
  rdb2      docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp
  web       /docker-entrypoint.sh ngin ...   Up      0.0.0.0:443->443/tcp,
                                                     0.0.0.0:80->80/tcp
  ```

<!-- omit in toc -->
### ▼サービス（docker　コンテナ）の稼働状態を確認

```shell
$ docker-compose ps
  Name                Command               State               Ports
--------------------------------------------------------------------------------
adminer   entrypoint.sh docker-php-e ...   Up      0.0.0.0:8080->8080/tcp
cache     docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
ddb       docker-entrypoint.sh mongod      Up      0.0.0.0:27017->27017/tcp
rdb1      docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp
rdb2      docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp
web       /docker-entrypoint.sh ngin ...   Up      0.0.0.0:443->443/tcp,
                                                    0.0.0.0:80->80/tcp
```

<!-- omit in toc -->
### ▼サービス（docker　コンテナ）をまとめて起動

- 初回の起動は、イメージのダウンロードやイメージのビルドが行われるため時間がかかる

<!-- omit in toc -->
#### ▽非デーモンモード

```shell
$ docker-compose up
Creating network "docker_default" with the default driver
Creating cache ... done
Creating rdb1  ... done
Creating rdb2  ... done
Creating ddb   ... done
Creating adminer ... done
Creating web     ... done
Attaching to cache, rdb2, ddb, rdb1, adminer, web
...
# Ctrl+C を入力
Gracefully stopping... (press Ctrl+C again to force)
Stopping adminer ... done
Stopping web     ... done
Stopping ddb     ... done
Stopping rdb2    ... done
Stopping rdb1    ... done
Stopping cache   ... done
```

- この方法だと、ログが標準出力に流れる
- 制御が返らないため、Ctrl+C で停止しなければならない
- Ctrl+C で停止すると、全てのコンテナが停止する

<!-- omit in toc -->
#### ▽デーモンモード

```shell
$ docker-compose up -d
Starting rdb1  ... done
Starting ddb   ... done
Starting cache ... done
Starting rdb2  ... done
Starting adminer ... done
Starting web     ... done
```

- この方法だと、ログが標準出力に流れない
- 制御がすぐに返ってきて、バックエンドでコンテが動作する
- 停止したい時は docker-compose down を使用する必要がある

<!-- omit in toc -->
### ▼一部のサービス（docker　コンテナ）を起動

<!-- omit in toc -->
#### ▽非デーモンモード

```shell
$ docker-compose up (サービス名)
```

<!-- omit in toc -->
#### ▽デーモンモード

```shell
$ docker-compose up -d (サービス名)
```

<!-- omit in toc -->
### ▼サービス（docker　コンテナ）をまとめて停止

```shell
$ docker-compose down
Stopping web     ... done
Stopping adminer ... done
Stopping ddb     ... done
Stopping cache   ... done
Stopping rdb1    ... done
Stopping rdb2    ... done
Removing web     ... done
Removing adminer ... done
Removing ddb     ... done
Removing cache   ... done
Removing rdb1    ... done
Removing rdb2    ... done
Removing network docker_default
```

<!-- omit in toc -->
### ▼一部のサービス（docker　コンテナ）を停止

```shell
$ docker-compose down (サービス名)
```

<!-- omit in toc -->
### ▼サービス（docker　コンテナ）をまとめて強制終了

```shell
$ docker-compose kill
```

<!-- omit in toc -->
### ▼一部のサービス（docker　コンテナ）を強制終了

```shell
$ docker-compose kill (サービス名)
```

---
## ■シェルスクリプトによる Docker プロビジョニングを行う場合

- Docker 自体のインストールとセットアップを Vagrant の docker プロビジョナーに任せず、独自に実施する方法

<!-- omit in toc -->
### ▼Vagrant プロビジョニング設定
- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

---
## ■Ansible による Docker プロビジョニングを行う場合

- Docker 自体のインストールとセットアップを Vagrant の docker プロビジョナーに任せず、独自に実施する方法

<!-- omit in toc -->
### ▼Vagrant プロビジョニング設定

- [testansible](https://github.com/gakimaru-on-connext/testansible#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

<!-- omit in toc -->
### ▼Ansible プロビジョニング準備

- [testansible](https://github.com/gakimaru-on-connext/testansible#ansible-%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E6%BA%96%E5%82%99) 参照

<!-- omit in toc -->
### ▼Ansible プロビジョニング実行

- [testansible](https://github.com/gakimaru-on-connext/testansible#ansible-%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E5%AE%9F%E8%A1%8C) 参照

---
## ■セキュアな Docker 操作方法

- Docker コマンドによる Docker サーバー操作は SSL 通信に対応している
  - 例えば、docker-machine コマンドで Docker コンテナホストをセットアップした場合は SSL通信設定が行われる
- 前述のシェルスクリプトまたは Ansible による Docker プロビジョニングを行った場合は、Docker サーバーにSSL通信が設定されるように構成している

<!-- omit in toc -->
### ▼セキュアな docker コマンドの実行方法１：VM にログインして docker コマンドを実行

- コンテナホスト上ではSSL通信ではなく Unix ソケットで直接通信するため、セキュア設定と関係なく普通にコマンドを扱える
  - [■Docker 操作方法](#docker-操作方法) と同じ

<!-- omit in toc -->
### ▼セキュアな docker コマンドの実行方法2：macOS から　docker コマンドを実行

<!-- omit in toc -->
#### ▽準備

- macOS

  ```shell
  # クライアント用の証明書ファイルをコピー
  $ CEERT_DST=$HOME/.docker/testdocker
  $ mkdir -p $CEERT_DST
  $ cd docker/ca
  $ cp ca.pem $CEERT_DST/.
  $ cp client-cert.pem $CEERT_DST/cert.pem
  $ cp client-key.pem $CEERT_DST/key.pem
  ```

<!-- omit in toc -->
#### ▽コマンド実行

- macOS

  ```shell
  # docker コマンドの接続先を環境変数で設定
  $ export DOCKER_HOST="tcp://192.168.56.10:2376"
  $ export DOCKER_MACHINE_NAME="testdocker"
  $ export DOCKER_TLS_VERIFY="1"
  $ export DOCKER_CERT_PATH="$HOME/.docker/testdocker"
  # docker コマンドを実行（何かしらのサブコマンドを指定すると、Docker サーバーにアクセスする）
  $ docker version
  Client: Docker Engine - Community
  Version:           20.10.17
  API version:       1.41
  ...
  OS/Arch:           darwin/amd64
  ...

  Server: Docker Engine - Community
  Engine:
    Version:          20.10.17
    API version:      1.41 (minimum version 1.12)
    ...
    OS/Arch:          linux/amd64
    ...
  ```

  - macOS 上から頻繁に docker コマンドを使用する場合は、これらの環境変数を ~/.zshrc に設定しておくなと便利

---
## ■ディレクトリ構成

```shell
testdocker/
├── README.html
├── README.md
├── docker/                      # Docker 用
│   ├── web/                     # Docker web コンテナ用
│   │   └── nginx/               # Docker web コンテナ：nginx 用
│   │       ├── conf.d/
│   │       │   └── default.conf
│   │       └── html/ 
│   │           ├── 50x.html
│   │           └── index.html
│   ├── docker-compose.yml       # Docker Compose コンテナ群設定ファイル
│   └── ca/                      # Docker サーバーSSL通信証明書用（未使用）
├── vagrant/                     # vagrant 用
│   ├── share/                   # vagrant 共有ディレクトリ（未使用）
│   └── Vagrantfile              # vagrant VM 設定
├── setup/                       # セットアップシェルスクリプト用（使用しない）
└── ansible/                     # Ansible 用（使用しない）
```

<!-- omit in toc -->
### ▼シェルスクリプトによる OS ＆ Docker プロビジョニングを行う場合

```shell
testdocker/
├── README.html
├── README.md
├── docker/                             # Docker 用
│   ├── ca/                             # Docker サーバーSSL通信証明書用
│   │   ├── ca-key.pem
│   │   ├── ca.pem                      # サーバー側／クライアント側証明書用
│   │   ├── client-cert.pem             # クライアント側証明書用
│   │   ├── client-extfile.cnf
│   │   ├── client-key.pem              # クライアント側証明書用
│   │   ├── client.csr
│   │   ├── how2make_cert.txt           # 証明書作成手順
│   │   ├── server-cert.pem             # サーバー側証明書用
│   │   ├── server-extfile.cnf
│   │   ├── server-key.pem              # サーバー側証明書用
│   │   └── server.csr
│   ├── web/                            # Docker web コンテナ用
│   │   └── nginx/                      # Docker web コンテナ：nginx 用
│   │       ├── conf.d/
│   │       │   └── default.conf
│   │       └── html/ 
│   │           ├── 50x.html
│   │           └── index.html
│   └── docker-compose.yml              # Docker Compose コンテナ群設定ファイル
├── setup/                              # セットアップシェルスクリプト／設定用
│   ├── setup_os.sh                     # 
│   └── setup_package_docker.sh         # 
├── vagrant/                            # vagrant 用
│   ├── share/                          # vagrant 共有ディレクトリ（未使用）
│   └── Vagrantfile                     # vagrant VM 設定
└── ansible/                            # Ansible 用（使用しない）
```

<!-- omit in toc -->
### ▼Ansible による OS ＆ Docker プロビジョニングを行う場合

```shell
testdocker/
├── README.html
├── README.md
├── ansible/                                      # Ansible 用
│   ├── playbook/                                 # Ansible プレイブック用
│   │   ├── inventories/                          # Ansible インベントリ用
│   │   │   ├── templates/                        # Ansible インベントリテンプレート用
│   │   │   │   ├── common/                       # Ansible インベントリ共通テンプレート
│   │   │   │   │   ├── __footer.yml
│   │   │   │   │   ├── __groups.yml
│   │   │   │   │   ├── __header.yml
│   │   │   │   │   └── __vars.yml
│   │   │   │   └── _(環境名)_hosts.yml            # Ansible インベントリ環境別テンプレート
│   │   │   └── (環境名)_hosts.yml                 # Ansible インベントリ（環境別）
│   │   ├── roles/                                # Ansible ロール用
│   │   │   ├── info_inventory/                   # Ansible ロール：インベントリ情報出力
│   │   │   │   └── tasks/
│   │   │   │       └── main.yml
│   │   │   ├── os_base_setup/                    # Ansible ロール：OS 基本セットアップ
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── vars/
│   │   │   │       └── vars.yml
│   │   │   ├── os_user_setup/                    # Ansible ロール：OS ユーザーセットアップ
│   │   │   │   ├── authorized_keys
│   │   │   │   │   ├── add/
│   │   │   │   │   │   └── *.pub
│   │   │   │   │   └── del/
│   │   │   │   │       └── *.pub
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── templates/
│   │   │   │       ├─ .bashrc.ext.j2
│   │   │   │       └── sudoers-user.j2
│   │   │   ├── package_docker_client_setup/      # Ansible ロール：パッケージ：Docker クライアントセットアップ
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── templates/
│   │   │   │       └─ .bashrc.docker.j2
│   │   │   ├── package_docker_common_setup/      # Ansible ロール：パッケージ：Docker サーバー／クライアント共通セットアップ
│   │   │   │   ├── files/
│   │   │   │   │   ├── ca.pem
│   │   │   │   │   ├── client-cert.pem
│   │   │   │   │   ├── client-key.pem
│   │   │   │   │   ├── readme.txt
│   │   │   │   │   ├── server-cert.pem
│   │   │   │   │   └── server-key.pem
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── vars/
│   │   │   │       └── vars.yml
│   │   │   └── package_docker_server_setup/      # Ansible ロール：パッケージ：Docker サーバーセットアップ
│   │   │       ├── handlers/
│   │   │       │   └── main.yml
│   │   │       ├── tasks/
│   │   │       │   ├── main.yml
│   │   │       │   └── restart_docker_server.yml
│   │   │       └── vars/
│   │   │           └── vars.yml
│   │   ├── vars/                                 # Ansible 共通変数用
│   │   │   └── common_vars.yml
│   │   ├── .ansible-lint                         # Ansible-lint 設定
│   │   ├── ansible.cfg                           # Ansible 基本設定
│   │   ├── playbook_info_print.yml               # Ansible プレイブック：情報表示
│   │   ├── playbook_os_setup.yml                 # Ansible プレイブック：OSセットアップ
│   │   ├── playbook_package_docker_setup.yml     # Ansible プレイブック：Docker セットアップ
│   │   └── site_all_setup.yml                    # Ansible サイト：全セットアップ
│   ├── _env.rc
│   ├── _provision.rc
│   ├── ansible_lint.sh                           # Ansible-lint 実行スクリプト
│   ├── ansible_lint_result.txt                   # Ansible-lint 実行結果
│   ├── inventories_setup.sh                      # Ansible インベントリセットアップスクリプト
│   ├── inventories_verify.sh                     # Ansible インベントリ検証スクリプト
│   └── provision_(環境名).sh                      # Ansible 実行スクリプト
├── docker/                                       # Docker 用
│   ├── ca/                                       # Docker サーバーSSL通信証明書用
│   │   ├── ca-key.pem
│   │   ├── ca.pem                                # サーバー側／クライアント側証明書用
│   │   ├── client-cert.pem                       # クライアント側証明書用
│   │   ├── client-extfile.cnf
│   │   ├── client-key.pem                        # クライアント側証明書用
│   │   ├── client.csr
│   │   ├── how2make_cert.txt                     # 証明書作成手順
│   │   ├── server-cert.pem                       # サーバー側証明書用
│   │   ├── server-extfile.cnf
│   │   ├── server-key.pem                        # サーバー側証明書用
│   │   └── server.csr
│   ├── web/                                      # Docker web コンテナ用
│   │   └── nginx/                                # Docker web コンテナ：nginx 用
│   │       ├── conf.d/
│   │       │   └── default.conf
│   │       └── html/ 
│   │           ├── 50x.html
│   │           └── index.html
│   └── docker-compose.yml                        # Docker Compose コンテナ群設定ファイル
├── vagrant/                                      # vagrant 用
│   ├── share/                                    # vagrant 共有ディレクトリ（未使用）
│   └── Vagrantfile                               # vagrant VM 設定
└── setup/                                        # セットアップシェルスクリプト用（使用しない）
```

----
以上
