.PHONY: all build test

VERSION:="v2.9"
PREVIOUS_VERSION="v2.8"
BIN:="docker run -it -v \"${PWD}:/workspace\" jsonschema"

all: build test

build:
	eval ${BIN} fmt --ignore test
	eval ${BIN} lint --fix --ignore test
	eval ${BIN} metaschema --ignore test
	eval ${BIN} bundle ${VERSION}/_root.json --resolve ${VERSION} --without-id > ${VERSION}/krakend.json
	eval ${BIN} fmt ${VERSION}/krakend.json

	eval ${BIN} bundle ${PREVIOUS_VERSION}/_root.json --resolve ${PREVIOUS_VERSION} --without-id > ${PREVIOUS_VERSION}/krakend.json
	eval ${BIN} fmt ${PREVIOUS_VERSION}/krakend.json

test:
	eval ${BIN} test ./test/${VERSION} --resolve ${VERSION}
	eval ${BIN} test ./test/${PREVIOUS_VERSION} --resolve ${PREVIOUS_VERSION}
