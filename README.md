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
- [■ディレクトリ構成](#ディレクトリ構成)

---
## ■概要

- Vagrant を用いた VM 上へのOSセットアップのテスト
- Docker（Docker Compose） によるセットアップを行う
- Docker 自体のセットアップも Vagrant に任せた構成
- シェル（スクリプト）によるセットアップと比較するためのリポジトリも用意
  - [https://github.com/gakimaru-on-connext/testvagrant](https://github.com/gakimaru-on-connext/testvagrant)
- Ansible によるセットアップと比較するためのリポジトリも用意
  - [https://github.com/gakimaru-on-connext/testansible](https://github.com/gakimaru-on-connext/testansible)

---
## ■動作要件

- macOS ※x86系のみ

- Oracle Virtualbox

  - https://www.oracle.com/jp/virtualization/technologies/vm/downloads/virtualbox-downloads.html

- Vagrant

  ```shell
  $ brew install vagrant
  ```

- Docker(クライアント用のコマンドラインツール) ※macOS 上から Docker を操作したい場合に必要（必須ではない）

  ```shell
  $ brew install docker
  ```

  - 注）cask ではないので注意
    - brew install --cask docker としてしまうと、Docker Engine をインストールしてしまう

---
## ■VM 操作方法

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#vm-%E6%93%8D%E4%BD%9C%E6%96%B9%E6%B3%95) 参照

---
## ■セットアップ内容

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E5%86%85%E5%AE%B9) と同じ

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

  - Docker Compose 用プラグインのインストール

    ```ruby
    install_plugin('vagrant-docker-compose')
    ```

  - OSイメージ

    ```ruby
    config.vm.box = "generic/ubuntu2204"
    ```

    - "generic/rocky9" では、Docker のインストールに対応していなかったため
    - シェルスクリプトやAnsibleによるセットアップに切り替える場合は、"generic/rocky9" に変更する必要あり

  - Docker Compose 設定および Docker コンテナ用設定ファイルの共有

    ```ruby
    config.vm.synced_folder "../docker", "/vagrant/docker", type: "rsync"
    ```

  - プロビジョニング設定：Docker のインストール

    ```ruby
    config.vm.provision :docker
    ```

    - :docker は、本来は Docker の操作を行うプロビジョナーだが、ここでは Docker のインストールにしか使用しないため、設定内容はこれだけ

  - プロビジョニング設定：Docker Compose の実行

    ```ruby
    config.vm.provision :docker_compose, yml: "/vagrant/docker/docker-compose.yml", run: "always"
    ```

    - run: "always" を指定し、2回目以降の Vagrant の起動でも Docker Compose が実行されるようにする

<!-- omit in toc -->
### ▼Docker Compose 設定

- docker/docker-compose.yml に各コンテナの設定を記述
- 

---
## ■Docker 操作方法

<!-- omit in toc -->
### ▼docker コマンドの実行方法１：VM にログインして docker コマンドを実行

- xxx

<!-- omit in toc -->
### ▼docker コマンドの実行方法2：macOS から　docker コマンドを実行(1)

- xxx
```shell
$ cd vagrant
$ vagrant ssh
$ cd /usr/lib/systemd/system
$ sudo vi docker.service
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
  ↓ 「--tls=false -H tcp://0.0.0.0:2375」を追加
ExecStart=/usr/bin/dockerd -H fd:// --tls=false -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

```shell
unset DOCKER_TLS_VERIFY
unset DOCKER_CERT_PATH
export DOCKER_HOST=tcp://192.168.56.10:2375
export DOCKER_MACHINE_NAME=testdocker
```

<!-- omit in toc -->
### ▼docker コマンドの実行方法3：macOS から　docker コマンドを実行(2)

- シェルスクリプトまたは Ansible から Docker をセットアップ
- Docker 接続用の証明書をコピー

  ```shell
  $ mkdir ~/.docker/testdocker
  $ cp setup/config/docker/ca/ca.pem $HOME/.docker/testdocker/.
  $ cp setup/config/docker/ca/client-cert.pem $HOME/.docker/testdocker/cert.pem
  $ cp setup/config/docker/ca/client-key.pem $HOME/.docker/testdocker/key.pem
  ```

- 環境変数を設定

  ```shell
  $ export DOCKER_TLS_VERIFY="1"
  $ export DOCKER_HOST="tcp://192.168.56.10:2376"
  $ export DOCKER_CERT_PATH="$HOME/.docker/testdocker"
  $ export DOCKER_MACHINE_NAME="testdocker"
  ```

<!-- omit in toc -->
### ▼docker コンテナにログイン

- xxx

<!-- omit in toc -->
### ▼docker コンテナの確認

- xxx

<!-- omit in toc -->
### ▼docker コンテナの停止（kill）

- xxx

<!-- omit in toc -->
### ▼docker コンテナイメージの破棄

- xxx

---
## ■Docker Compose 操作方法

<!-- omit in toc -->
### ▼docker コマンドの実行方法：VM にログインして docker-compose コマンドを実行

- xxx

<!-- omit in toc -->
### ▼docker コンテナをまとめて起動（非デーモンモード）

- xxx

<!-- omit in toc -->
### ▼docker コンテナをまとめて起動（デーモンモード）

- xxx

<!-- omit in toc -->
### ▼docker コンテナをまとめて停止

- xxx

<!-- omit in toc -->
### ▼docker コンテナの一部を停止

- xxx

<!-- omit in toc -->
### ▼docker コンテナの一部を起動

- xxx

---
## ■シェルスクリプトによる Docker プロビジョニングを行う場合

<!-- omit in toc -->
### ▼Vagrant プロビジョニング設定
- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

---
## ■Ansible による Docker プロビジョニングを行う場合

<!-- omit in toc -->
### ▼Vagrant プロビジョニング設定

- [testansible](https://github.com/gakimaru-on-connext/testansible#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

<!-- omit in toc -->
### ▼準備

- [testansible](https://github.com/gakimaru-on-connext/testansible#ansible-%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E6%BA%96%E5%82%99) 参照

<!-- omit in toc -->
### ▼実行

- [testansible](https://github.com/gakimaru-on-connext/testansible#ansible-%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E5%AE%9F%E8%A1%8C) 参照

---
## ■ディレクトリ構成

```shell
testdocker/
├── README.html
├── README.md
├── docker/
│   ├── docker-compose.yml
│   └── web/
│       └── nginx/
│           ├── conf.d/
│           │   └── default.conf
│           └── html/
│               ├── 50x.html
│               └── index.html
└── vagrant/
    ├── share/
    └── Vagrantfile
```

<!-- omit in toc -->
### ▼シェルスクリプトによる OS ＆ Docker セットアップを行う場合
```shell
testdocker/
├── README.html
├── README.md
├── docker/
│   ├── docker-compose.yml
│   └── web/
│       └── nginx/
│           ├── conf.d/
│           │   └── default.conf
│           └── html/
│               ├── 50x.html
│               └── index.html
├── setup/
│   ├── config/
│   │   ├── docker/
│   │   │   ├── ca/
│   │   │   │   ├── ca-key.pem
│   │   │   │   ├── ca.pem
│   │   │   │   ├── client-cert.pem
│   │   │   │   ├── client-extfile.cnf
│   │   │   │   ├── client-key.pem
│   │   │   │   ├── client.csr
│   │   │   │   ├── server-cert.pem
│   │   │   │   ├── server-extfile.cnf
│   │   │   │   ├── server-key.pem
│   │   │   │   └── server.csr
│   │   │   └── how2make_cert.txt
│   │   └── etc/
│   │       └── yum.repos.d
│   │           └── mongodb-org-6.0.repo
│   ├── setup_os.sh
│   └── setup_package_docker.sh
└── vagrant/
    ├── share/
    └── Vagrantfile
```

<!-- omit in toc -->
### ▼Ansible による OS ＆ Docker セットアップを行う場合に使用するファイル
```shell
testdocker/
├── README.html
├── README.md
├── ansible/
│   ├── playbook/
│   │   ├── inventories/
│   │   │   ├── templates/
│   │   │   │   ├── common/
│   │   │   │   │   ├── __footer.yml
│   │   │   │   │   ├── __groups.yml
│   │   │   │   │   ├── __header.yml
│   │   │   │   │   └── __vars.yml
│   │   │   │   └── _(環境名)_hosts.yml            # Ansible インベントリ環境別テンプレート
│   │   │   └── (環境名)_hosts.yml                 # Ansible インベントリ（環境別）
│   │   ├── roles/
│   │   │   ├── info_inventory/
│   │   │   │   └── tasks/
│   │   │   │       └── main.yml
│   │   │   ├── os_base_setup/
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── vars/
│   │   │   │       └── vars.yml
│   │   │   ├── os_user_setup/
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
│   │   │   ├── package_docker_client_setup/
│   │   │   │   ├── tasks/
│   │   │   │   │   └── main.yml
│   │   │   │   └── templates/
│   │   │   │       └─ .bashrc.docker.j2
│   │   │   ├── package_docker_common_setup/
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
│   │   │   └── package_docker_server_setup/
│   │   │       ├── handlers/
│   │   │       │   └── main.yml
│   │   │       ├── tasks/
│   │   │       │   ├── main.yml
│   │   │       │   └── restart_docker_server.yml
│   │   │       └── vars/
│   │   │           └── vars.yml
│   │   ├── vars/
│   │   │   └── common_vars.yml
│   │   ├── .ansible-lint                         # Ansible-lint 設定
│   │   ├── ansible.cfg
│   │   ├── playbook_info_print.yml
│   │   ├── playbook_os_setup.yml
│   │   ├── playbook_package_docker_setup.yml
│   │   └── site_all_setup.yml
│   ├── _env.rc
│   ├── _provision.rc
│   ├── ansible_lint.sh
│   ├── ansible_lint_result.txt
│   ├── inventories_setup.sh
│   ├── inventories_verify.sh
│   └── provision_vagrant.sh
├── docker/
│   ├── docker-compose.yml
│   └── web/
│       └── nginx/
│           ├── conf.d/
│           │   └── default.conf
│           └── html/
│               ├── 50x.html
│               └── index.html
├── setup/
│   └── config/
│       └── docker/
│           ├── ca/
│           │   ├── ca-key.pem
│           │   ├── ca.pem
│           │   ├── client-cert.pem
│           │   ├── client-extfile.cnf
│           │   ├── client-key.pem
│           │   ├── client.csr
│           │   ├── server-cert.pem
│           │   ├── server-extfile.cnf
│           │   ├── server-key.pem
│           │   └── server.csr
│           └── how2make_cert.txt
└── vagrant/
    ├── share/
    └── Vagrantfile
```

----
以上
