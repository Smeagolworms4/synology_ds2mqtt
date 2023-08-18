export DOCKER_NAME=ds2mqtt

RULE_DEP_UP=history

include .env.local

.env.local:
	@echo "Init your environment:"
	@echo ""
	@read -p "	- Enter your DS_URL (ex: http://192.168.1.100): " DS_URL; echo "DS_URL=$$DS_URL" > .env.local
	@read -p "	- Enter your DS_LOGIN: " DS_LOGIN; echo "DS_LOGIN=$$DS_LOGIN" >> .env.local
	@read -p "	- Enter your DS_PASSWORD: " DS_PASSWORD; echo "DS_PASSWORD=$$DS_PASSWORD" >> .env.local
	@echo ""

# external resource #
export MAKEFILE_URL=https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master

# import #
$(shell [ ! -f docker/.makefiles/index.mk ] && mkdir -p docker/.makefiles && curl -L --silent -f $(MAKEFILE_URL)/docker-compose.mk -o docker/.makefiles/index.mk)
include docker/.makefiles/index.mk

# Add variable on documentation #
export MQTT_EXPLORER_PORT    ## HTTP port (default: 8080)
export DEBUG_PORT            ## HTTP port (default: 9229)


###################
# Logs containers #
###################

## Display logs `ds2mqtt`
ds2mqtt-logs:
	$(COMPOSE) logs -f ds2mqtt

######################
# Connect containers #
######################

## Connect to `ds2mqtt`
ds2mqtt-bash:
	$(COMPOSE) exec -u node ds2mqtt env $(FIX_SHELL) sh -l

## Connect to `ds2mqtt` in root
ds2mqtt-bash-root:
	$(COMPOSE) exec ds2mqtt env $(FIX_SHELL) sh -l

###############
# Development #
###############

## Init all project
init: ds2mqtt-install

## Install package for `ds2mqtt`
ds2mqtt-install:
	$(COMPOSE) exec -u node ds2mqtt env $(FIX_SHELL) npm install

## Build to `ds2mqtt`
ds2mqtt-build:
	$(COMPOSE) exec -u node ds2mqtt env $(FIX_SHELL) npm run build

## Start to `ds2mqtt` (mode production)
ds2mqtt-start:
	$(COMPOSE) exec -u node ds2mqtt env $(FIX_SHELL) npm run start

## Watch to `ds2mqtt` (mode development)
ds2mqtt-watch:
	$(COMPOSE) exec -u node ds2mqtt env $(FIX_SHELL) npm run watch

#########
# Utils #
#########

history: history_ds2mqtt

history_ds2mqtt:
	@if [ ! -f $(DOCKER_PATH)/.history_ds2mqtt ]; then touch $(DOCKER_PATH)/.history_ds2mqtt; fi
