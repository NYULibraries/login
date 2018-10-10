#!/bin/sh -e

: "${ECR_DOMAIN?Must specify ECR_DOMAIN}"

tag=login
subtags="test unicorn"

for subtag in $subtags
do
  docker tag $tag_$subtag $ECR_DOMAIN/$tag_$subtag:latest
  docker tag $tag_$subtag $ECR_DOMAIN/$tag_$subtag:${CIRCLE_BRANCH//\//_}
  docker tag $tag_$subtag $ECR_DOMAIN/$tag_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done

for subtag in $subtags
do
  docker push $ECR_DOMAIN/$tag_$subtag:latest
  docker push $ECR_DOMAIN/$tag_$subtag:${CIRCLE_BRANCH//\//_}
  docker push $ECR_DOMAIN/$tag_$subtag:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
done
