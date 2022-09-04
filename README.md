<!-- omit in toc -->
# Docker Test

[https://github.com/gakimaru-on-connext/testansible](https://github.com/gakimaru-on-connext/testansible)

---
- [■概要](#概要)
- [■動作要件](#動作要件)
- [■ディレクトリ構成](#ディレクトリ構成)

---
## ■概要

- Vagrant を用いた VM 上へのOSセットアップのテスト
- Docker によるセットアップを行う
- OS と Docker 自体のセットアップのみ Ansible を使用
  - シェルスクリプトでも可

---
## ■動作要件

- macOS ※x86系のみ

- Oracle Virtualbox

  - https://www.oracle.com/jp/virtualization/technologies/vm/downloads/virtualbox-downloads.html

- Vagrant

  ```shell
  $ brew install vagrant
  ```

- Python3

  ```shell
  $ brew install python3
  ```

- Ansible

  ```shell
  $ brew install ansible
  ```

- Docker(クライアント用のコマンドラインツール)

  ```shell
  $ brew install docker
  ```

  - 注）cask ではないので注意
    - brew install --cask docker としてしまうと、Docker Engine をインストールしてしまう

---
## ■ディレクトリ構成

```
```

----
以上
