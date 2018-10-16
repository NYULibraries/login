#!/bin/sh -e

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"

docker pull $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_} || docker pull $ECR_DOMAIN/login:latest

subtags="test"

for subtag in $subtags
do
  docker pull $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_} || docker pull $ECR_DOMAIN/login_$subtag:latest
done
