#!/bin/sh -e

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"

subtags="test unicorn"

for subtag in $subtags
do
  docker pull $ECR_DOMAIN/login_$subtag:${CIRCLE_BRANCH//\//_} || docker pull $ECR_DOMAIN/login_$subtag:latest
done
