#!/bin/sh -e

: "${IMAGES_DOMAIN?Must specify IMAGES_DOMAIN}"

docker tag login $IMAGES_DOMAIN/login:latest
docker tag login $IMAGES_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker tag login $IMAGES_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push $IMAGES_DOMAIN/login:latest
docker push $IMAGES_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker push $IMAGES_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

subtags="test"

for subtag in $subtags
do
  docker tag login_$subtag $IMAGES_DOMAIN/login_$subtag:latest
  docker tag login_$subtag $IMAGES_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}
  docker tag login_$subtag $IMAGES_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done

for subtag in $subtags
do
  docker push $IMAGES_DOMAIN/login_$subtag:latest
  docker push $IMAGES_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}
  docker push $IMAGES_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done
