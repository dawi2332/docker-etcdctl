GPG=gpg2
ETCD_VERSION=v0.4.6
ETCD_DIR=etcd-$(ETCD_VERSION)-linux-amd64
ETCD_TGZ=$(ETCD_DIR).tar.gz
ETCD_GPG=$(ETCD_TGZ).gpg
DOCKER_USERNAME=dawi2332
DOCKER_NAME=etcdctl
DOCKER_TAG=$(DOCKER_USERNAME)/$(DOCKER_NAME):$(ETCD_VERSION)

.PHONY=all deps build push clean clean

all: run

run: build
	docker run -it --rm $(DOCKER_TAG)

build: deps
	docker build -t $(DOCKER_TAG) .

deps: etcdctl

etcdctl: $(ETCD_DIR)
	cp $(ETCD_DIR)/etcdctl .

clean:
	-rm -f $(ETCD_TGZ)
	-rm -f $(ETCD_GPG)
	-rm -rf $(ETCD_DIR)
	-rm -f etcdctl

$(ETCD_GPG):
	wget https://github.com/coreos/etcd/releases/download/$(ETCD_VERSION)/$(ETCD_GPG)

$(ETCD_DIR): $(ETCD_GPG)
	$(GPG) --decrypt $(ETCD_GPG) | tar -xzf -
