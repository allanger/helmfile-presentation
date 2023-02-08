ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

vendor_chart:
	@echo "Vendoring $(chart) $(version)"
	@mkdir $(ROOT_DIR)/.tmp/$(chart)/$(version) -p
	@helm pull $(chart) -d $(ROOT_DIR)/.tmp/$(chart)/$(version) --untar --version $(version)
	@if [ ! -d  $(ROOT_DIR)/vendor/$(chart)-$(version) ]; then\
		mkdir -p $(ROOT_DIR)/vendor/$(chart)-$(version) &&\
		cp -R $(ROOT_DIR)/.tmp/*/* $(ROOT_DIR)/vendor/$(chart)-$(version);\
	fi
	@rm -rf $(ROOT_DIR)/.tmp/$(chart)/$(version)

build: 
	docker build -t gcx-helmfile .

diff:
	docker run --rm --net=host -v "${HOME}/.kube:/helm/.kube" -v "${HOME}/.config/helm:/root/.config/helm" -v "${PWD}:/wd" --workdir /wd -it gcx-helmfile helmfile -e cluster_test diff

apply:
	docker run --rm --net=host -v "${HOME}/.kube:/helm/.kube" -v "${HOME}/.config/helm:/root/.config/helm" -v "${PWD}:/wd" --workdir /wd -it gcx-helmfile helmfile -e cluster_test apply

destroy:
	docker run --rm --net=host -v "${HOME}/.kube:/helm/.kube" -v "${HOME}/.config/helm:/root/.config/helm" -v "${PWD}:/wd" --workdir /wd -it gcx-helmfile helmfile -e cluster_test destroy

lint:
	docker run --rm --net=host -v "${HOME}/.kube:/helm/.kube" -v "${HOME}/.config/helm:/root/.config/helm" -v "${PWD}:/wd" --workdir /wd -it gcx-helmfile helmfile -e cluster_test lint
