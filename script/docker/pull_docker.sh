#!/bin/sh -e

docker pull nyulibraries/login:${CIRCLE_BRANCH//\//_} || docker pull nyulibraries/login:latest

subtags="test"

for subtag in $subtags
do
  docker pull nyulibraries/login_$subtag:${CIRCLE_BRANCH//\//_} || docker pull nyulibraries/login_$subtag:latest
done
