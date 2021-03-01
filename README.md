![Grey Systems](https://ci4.googleusercontent.com/proxy/QIT7f77BFdQFLagsiHBnvROm1h_A4-bd5sluu9zkpCTjMNV4yRCBIpxGuF2_l9lzrr98VBlgQQwYmV5fT6w4iy4nh3vou9y7thyMA8t0wcyj73DvdgAtZUOIFbZiwQ1LFBkpyVC1ludibIIhtA2inlKQ=s0-d-e1-ft#https://drive.google.com/a/reacciona.es/uc?id=1t_-o_GDpzyDhcJc4u8EJ8cslqZS_D_XM&export=download)

# maven3-awscli-java11

![Status](https://github.com/grey-systems/maven3-awscli-java11-dockerfile/actions/workflows/build-push-dockerfile.yml/badge.svg)

## Description
This image was thinking to build and push our microservices based on java11 and maven to a private ECR repository.

These are the tools included in the image:

* mvn-version.sh
* ecr-repo-uri.sh
* autotools
* awscli
* python3
* unzip
* git
* xmlstarlet
* jq
* zsh

## How to use this image
The mainly idea when we built this image is to use in our CI pipelines as the base runtime where our java applications will be tested, compiled and pushed to our repositories. If you want to use this image tool, feel free to download from dockerhub:

```shell
docker pull greysystems/maven3-awscli-java11:1.0.0
```

Furthermore, you can use this image as an isolated java11/maven3 environment. It can be very usefull if you don't want to install in your local machine the required tools to compile and run java applications. Find below an example running a java application using this docker image:

```shell
docker run -v $(pwd):/mnt/code greysystems/maven3-awscli-java11:1.0.0 java -jar your-java11-service.jar
```

## Custom tools included in the image:

### mvn-version.sh
Bash script capable of get the version set in the repository's pom.xml.

Usage:

Get the repository's version:

```shell
mvn-version.sh your-repository-path
```

Also, you can get the script usage typping `mvn-version.sh -h`

### ecr-repo-uri.sh

You can use this bash script to check whether name is an existing ECR repository and prints its URI. 
If the repository does not exist, it could be created using this script too.

Please, note that to use this script, the docker daemon should be allowed to pull and push images from your ECR repository. Simply, do aws ecr login before use this script:

`aws ecr get-login --region $YOUR-AWS-ECR-ACCOUNT-REGION --no-include-email`

Usage:

```shell
ecr-repo-uri.sh $YOUR-SERVICE-NAME
```
It will return the URI associated with this resource in AWS.

```shell
ecr-repo-uri.sh -c $YOUR-SERVICE-NAME
```
Create new resource in ECR with the given service name. It will return the generated resource URI too.

Also, you can get the script usage typping `mvn-version.sh -h`


## Bug Reports

Bug reports can be sent directly to authors and/or using github's issues.
