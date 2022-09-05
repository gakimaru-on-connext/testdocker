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
- [■Ansible によるプロビジョニング時の準備](#ansible-によるプロビジョニング時の準備)
- [■Ansible によるプロビジョニング時の実行](#ansible-によるプロビジョニング時の実行)
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
### ▼Admier

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
### ▼Docker プロビジョニング設定

- xxx

<!-- omit in toc -->
### ▼Docker Compose プロビジョニング設定

- xxx

<!-- omit in toc -->
### ▼シェルスクリプトによるプロビジョニングの場合

- [testvagrant](https://github.com/gakimaru-on-connext/testvagrant#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

<!-- omit in toc -->
### ▼Ansible によるプロビジョニングの場合

- [testansible](https://github.com/gakimaru-on-connext/testansible#%E8%A7%A3%E8%AA%AC%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0) 参照

---
## ■Ansible によるプロビジョニング時の準備

- [testansible](https://github.com/gakimaru-on-connext/testansible#ansible-%E3%83%97%E3%83%AD%E3%83%93%E3%82%B8%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E6%BA%96%E5%82%99) 参照

---
## ■Ansible によるプロビジョニング時の実行

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
