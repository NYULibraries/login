#!/bin/sh -e

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"

docker tag login $ECR_DOMAIN/login:latest
docker tag login $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker tag login $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push $ECR_DOMAIN/login:latest
docker push $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker push $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

subtags="test"

for subtag in $subtags
do
  docker tag login_$subtag $ECR_DOMAIN/login_$subtag:latest
  docker tag login_$subtag $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}
  docker tag login_$subtag $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done

for subtag in $subtags
do
  docker push $ECR_DOMAIN/login_$subtag:latest
  docker push $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}
  docker push $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done
