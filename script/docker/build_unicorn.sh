#!/bin/bash

ln -fs .dockerignore.prod .dockerignore
docker-compose build unicorn