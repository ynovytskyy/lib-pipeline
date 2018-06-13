#!/bin/bash
set -eux

export ROOT_FOLDER="$( pwd )"
M2_HOME="${HOME}/.m2"
M2_CACHE="${ROOT_FOLDER}/maven"

echo "Root folder is [${ROOT_FOLDER}]"
echo "M2 Home folder is [${M2_HOME}]"
echo "M2 Cache folder is [${M2_CACHE}]"

pushd source

	./mvnw clean package #deploy

popd
