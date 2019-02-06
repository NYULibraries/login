#!/bin/sh -ex

docker tag login quay.io/nyulibraries/login:latest
docker tag login quay.io/nyulibraries/login:${CIRCLE_BRANCH//\//_}
docker tag login quay.io/nyulibraries/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker tag login_test quay.io/nyulibraries/login_test:latest
docker tag login_test quay.io/nyulibraries/login_test:${CIRCLE_BRANCH//\//_}
docker tag login_test quay.io/nyulibraries/login_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push quay.io/nyulibraries/login:latest
docker push quay.io/nyulibraries/login:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push quay.io/nyulibraries/login_test:latest
docker push quay.io/nyulibraries/login_test:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/login_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
