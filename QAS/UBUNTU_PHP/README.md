# Docker for QAShot
## Info
- The Dockerfile is an ubuntu version of the Wodby docker4drupal PHP image
    - https://github.com/Wodby/drupal-php/tree/master/7.0
- It's based on the ```phusion/baseimage:0.9.22```
- Notes:
    - As of 2017.10.17. the versioning of the images will follow the version of BackstopJS.
    - The additional contents will be listed here.

## Build
- Build
    - ```docker build -t drupal_php . --no-cache --rm```
    - ```docker build -t drupal_php . --no-cache --rm -t havelantmate/drupal_php:3.0.29```
- Lint
    - ```~/www/docker/node_modules/dockerfilelint/bin/dockerfilelint ~/www/docker/QAS/UBUNTU_PHP/Dockerfile```
- Cleanup
    - ```docker container ps -a and manually remove stuck containers, if any.```
    - ```docker rmi $(docker images -f "dangling=true" -q)```
    - ```docker volume rm $(docker volume ls -qf dangling=true)```
- Publish
    - ```docker login```
    - ```docker images and get the image hash```
    - ```docker tag <hash> havelantmate/drupal_php:<tag>```
    - ```docker push havelantmate/drupal_php```

## Contents
|Name|Version|
|---|---|
|BackstopJS|3.0.29|
|chromy|0.5.5|
|casperjs|1.1.4|
|slimerjs|0.10.3|
|phantomjs-prebuilt|2.1.1|
|composer|1.5.2|
|hirak/prestissimo|0.3.7|
|google-chrome-beta|62.0.3202.52|
|firefox-esr|52.4.0|
|php|7.0.22|
|nodejs|6.11.4|
|npm|3.10.10|
