#!/bin/sh -ex

docker pull quay.io/nyulibraries/login:${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/login:latest
docker pull quay.io/nyulibraries/login_test:${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/login_test:latest
