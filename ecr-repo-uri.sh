#!/bin/zsh
# -*- vim:fenc=utf-8:et:sw=2:ts=2:sts=2
#
setopt local_options
setopt local_traps
unsetopt glob_subst

#set -o errexit
set -o nounset

typeset -a create_flag help_flag version_flag

PROGNAME=${0:t}
PROGDIR=${0:h}
BUG_REPORT=enrico.m.crisostomo@gmail.com
PACKAGE_VERSION=1.0.0-develop

AWS_OUTPUT="--output json"

REQUIRED_PROGS=( aws jq )

check_progs()
{
  for p in ${REQUIRED_PROGS}
  do
    command -v ${p} > /dev/null 2>&1 ||
      {
        >&2 print -- Cannot find required program: ${p}
        exit 1
      }
  done
}

print_version()
{
  print -- "${PROGNAME} ${PACKAGE_VERSION}"
  print -- "Copyright (C) 2017 Enrico M. Crisostomo"
  print -- "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
  print -- "This is free software: you are free to change and redistribute it."
  print -- "There is NO WARRANTY, to the extent permitted by law."
  print
  print -- "Written by Enrico M. Crisostomo"
}

print_usage()
{
  print -- "${PROGNAME}"
  print
  print -- "Usage:"
  print -- "${PROGNAME} name"
  print
  print -- "Checks whether name is an existing ECR repository and prints its URI."
  print -- "Non existing repositories can optionally be created."
  print
  print -- "Options:"
  print -- " -c, --create   Create repository if it does not exist."
  print -- " -h, --help     Print this message."
  print -- "     --version  Print the program version."
}

# Main
zparseopts -D \
           c=create_flag -create=create_flag \
           h=help_flag -help=help_flag \
           -version=version_flag

if (( ${+help_flag[1]} > 0 ))
then
  print_usage
  exit 0
fi

if (( ${+version_flag[1]} > 0 ))
then
  print_version
  exit 0
fi

(( $# == 1 )) || {
  print -- Invalid number of arguments.
  return 1
}

check_progs

SERVICE_NAME=$1

ECR_DESCRIBE_REPO_OUTPUT=$(aws ecr describe-repositories ${=AWS_OUTPUT} --repository-names ${SERVICE_NAME} 2> /dev/null)

if (( $? != 0 ))
then
  if (( ${+create_flag[1]} == 0 ))
  then
    print "Cannot find ECR repository ${SERVICE_NAME}"
    return 1
  fi

  aws ecr create-repository ${=AWS_OUTPUT} --repository-name ${SERVICE_NAME} > /dev/null
  ECR_DESCRIBE_REPO_OUTPUT=$(aws ecr describe-repositories ${=AWS_OUTPUT} --repository-names ${SERVICE_NAME})

  if (( $? != 0 ))
  then
    echo "Cannot find or create ECR repository ${SERVICE_NAME}"
    return 1
  fi
fi

ECR_REPO_URI=$(printf "%s\n" ${ECR_DESCRIBE_REPO_OUTPUT} | jq -r ".repositories[] | .repositoryUri")

if [[ -z ${ECR_REPO_URI} ]]
then
   echo "Cannot find ECR repository ${SERVICE_NAME}"
   return 1
fi

print ${ECR_REPO_URI}

# Local variables:
# coding: utf-8
# mode: sh
# eval: (sh-set-shell "zsh")
# tab-width: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# sh-indentation: 2
# End:
