#!/bin/bash

ln -fs .dockerignore.test .dockerignore
docker-compose build test