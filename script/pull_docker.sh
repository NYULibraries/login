#!/bin/sh

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"
IMAGE_NAME=login

# check if branch tag exists
aws ecr describe-images --region us-east-1 --repository-name=librarynyuedu_jekyll --image-ids=imageTag=${CIRCLE_BRANCH//\//_}

if [ $? -eq 0 ]; then
  docker pull $ECR_DOMAIN/$IMAGE_NAME:${CIRCLE_BRANCH//\//_}
else
  docker pull $ECR_DOMAIN/$IMAGE_NAME:latest
fi
