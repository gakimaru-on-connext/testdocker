# see also: https://docs.docker.jp/v19.03/engine/security/https.html

$ cd testdocker/docker/ca

$ openssl genrsa -aes256 -out ca-key.pem 4096
Enter pass phrase for ca-key.pem: <--- pass

$ openssl req -new -x509 -days 3650 -key ca-key.pem -sha256 -out ca.pem
-----
Country Name (2 letter code) []:JP
State or Province Name (full name) []:Niigata
Locality Name (eg, city) []:Murakami
Organization Name (eg, company) []:on-connext
Organizational Unit Name (eg, section) []:Development
Common Name (e.g. server FQDN or YOUR name) []:testdocker.localdomain
Email Address []:vagrant@testdocker.localdomain

$ openssl genrsa -out server-key.pem 4096

$ openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

$ echo subjectAltName = IP:192.168.56.10,IP:127.0.0.1 > server-extfile.cnf

$ openssl x509 -req -days 3650 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-extfile.cnf

$ openssl genrsa -out key.pem 4096

$ openssl req -subj '/CN=client' -new -key key.pem -out client.csr

$ echo extendedKeyUsage = clientAuth > client-extfile.cnf

$ openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile client-extfile.cnf

$ mkdir csr

$ mv *.csr *.cnf csr/.

$ chmod -v 0400 ca-key.pem key.pem server-key.pem

$ chmod -v 0444 ca.pem server-cert.pem cert.pem

# for /usr/lib/systemd/system/docker.servive

$ dockerd --tlsverify --tlscacert=testdocker/docker/ca/ca.pem --tlscert=testdocker/docker/ca/server-cert.pem --tlskey=testdocker/docker/ca/server-key.pem -H=0.0.0.0:2376

# for ~/.zshrc
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.56.10:2376"
export DOCKER_CERT_PATH="/Users/itagaki/works/ox/test/testdocker/docker/ca"
export DOCKER_MACHINE_NAME="testdocker"

