# Docker for QAShot
## Info
- The Dockerfile is an ubuntu version of the Wodby docker4drupal PHP image
    - https://github.com/Wodby/drupal-php/tree/master/7.0
- It's based on the ```phusion/baseimage:0.9.22```

## Build
- Build
    - ```docker build -t drupal_php . --no-cache --rm```
    - ```docker build -t drupal_php . --no-cache --rm -t havelantmate/drupal_php:Backstop2.6.13-SlimerJS```
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
- backstopjs v3.0.26
- chromy v0.5.2
- casperjs v1.1.4
- slimerjs v0.10.3
- phantomjs-prebuilt v2.1.15
- composer v1.5.2
    - hirak/prestissimo v0.3.7
- google-chrome-stable v61.0.3163.100-1
- firefox-esr v52.4.0esr-1~16.04.york0
- php v7.0.22-0ubuntu0.16.04.1
- nodejs v7.10.1-2nodesource1~xenial1
