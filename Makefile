ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

vendor_chart:
	@echo "Vendoring $(chart) $(version)"
	@mkdir $(ROOT_DIR)/.tmp
	@helm pull $(chart) -d $(ROOT_DIR)/.tmp --untar --version $(version)
	@mkdir -p $(ROOT_DIR)/vendor/$(chart)-$(version)
	@cp -R $(ROOT_DIR)/.tmp/*/* $(ROOT_DIR)/vendor/$(chart)-$(version)
	@rm -rf $(ROOT_DIR)/.tmp
