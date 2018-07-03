# Build
Instructions on how to build the image.
- Lint
    - ```../linter/hadolint Dockerfile```

- Build
    - For testing:
        - ```docker build -t havelantmate/docker-behat . --no-cache --rm```
    - For RC:
        - ```docker build -t havelantmate/docker-behat . --no-cache --rm -t havelantmate/docker-behat:1.1.0```

- Cleanup
    - ```docker container ps -a and manually remove stuck containers, if any.```
    - ```docker rmi $(docker images -f "dangling=true" -q)```
    - ```docker volume rm $(docker volume ls -qf dangling=true)```

- Publish
    - ```docker login```
    - If it wasn't tagged at build time:
        - ```docker images and get the image hash```
        - ```docker tag <hash> havelantmate/docker-behat:<tag>```
    - ```docker push havelantmate/docker-behat```
