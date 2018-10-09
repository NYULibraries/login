#!/bin/sh -e

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"

docker tag login $ECR_DOMAIN/login:latest
docker push $ECR_DOMAIN/login:latest
docker tag login $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker push $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}
docker tag login $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push $ECR_DOMAIN/login:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker tag login_test $ECR_DOMAIN/login_test:latest
docker push $ECR_DOMAIN/login_test:latest
docker tag login_test $ECR_DOMAIN/login_test:${CIRCLE_BRANCH//\//_}
docker push $ECR_DOMAIN/login_test:${CIRCLE_BRANCH//\//_}
docker tag login_test $ECR_DOMAIN/login_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push $ECR_DOMAIN/login_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
