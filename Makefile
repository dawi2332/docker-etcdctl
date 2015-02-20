GPGV=gpgv2
ETCD_VERSION=v0.4.6
ETCD_DIR=etcd-$(ETCD_VERSION)-linux-amd64
ETCD_TGZ=$(ETCD_DIR).tar.gz
ETCD_SIG=$(ETCD_TGZ).gpg
DOCKER_USERNAME=dawi2332
DOCKER_NAME=etcdctl
DOCKER_TAG=$(DOCKER_USERNAME)/$(DOCKER_NAME):$(ETCD_VERSION)

.PHONY=all deps build push clean clean

all: run

run: build
	docker run -it --rm $(DOCKER_TAG)

build: deps
	docker build -t $(DOCKER_TAG) .

deps: $(ETCD_DIR)
	cp $(ETCD_DIR)/etcdctl .

clean:
	-rm -f $(ETCD_TGZ)
	-rm -f $(ETCD_SIG)
	-rm -rf $(ETCD_DIR)
	-rm -f etcdctl

$(ETCD_TGZ):
	wget https://github.com/coreos/etcd/releases/download/$(ETCD_VERSION)/$(ETCD_DIR).tar.gz

$(ETCD_SIG):
	wget https://github.com/coreos/etcd/releases/download/$(ETCD_VERSION)/$(ETCD_DIR).tar.gz.gpg

$(ETCD_DIR): $(ETCD_TGZ) $(ETCD_SIG)
	$(GPGV) $(ETCD_SIG)
	tar -xzf $(ETCD_TGZ)
