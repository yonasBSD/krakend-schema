.PHONY: all build test

VERSION:="v2.13"
PREVIOUS_VERSION="v2.12"
BIN:="docker run -it -v \"${PWD}:/workspace\" ghcr.io/sourcemeta/jsonschema:v7.2.1"

all: build test

build:
	eval ${BIN} fmt --ignore test --extension .json
	eval ${BIN} lint --fix --ignore test --extension .json
	eval ${BIN} metaschema --ignore test --extension .json
	eval ${BIN} bundle ${VERSION}/_root.json --resolve ${VERSION} --without-id > ${VERSION}/krakend.json
	eval ${BIN} fmt ${VERSION}/krakend.json

	eval ${BIN} bundle ${PREVIOUS_VERSION}/_root.json --resolve ${PREVIOUS_VERSION} --without-id > ${PREVIOUS_VERSION}/krakend.json
	eval ${BIN} fmt ${PREVIOUS_VERSION}/krakend.json

test:
	eval ${BIN} test ./test/${VERSION} --resolve ${VERSION}
	eval ${BIN} test ./test/${PREVIOUS_VERSION} --resolve ${PREVIOUS_VERSION}
