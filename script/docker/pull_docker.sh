#!/bin/sh -e

: "${IMAGES_DOMAIN?Must specify IMAGES_DOMAIN}"

docker pull $IMAGES_DOMAIN/login:${CIRCLE_BRANCH//\//_} || docker pull $IMAGES_DOMAIN/login:latest

subtags="test"

for subtag in $subtags
do
  docker pull $IMAGES_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_} || docker pull $IMAGES_DOMAIN/login_$subtag:latest
done
