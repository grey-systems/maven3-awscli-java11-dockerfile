#!/bin/zsh
# -*- coding: utf-8; tab-width: 2; indent-tabs-mode: nil; sh-basic-offset: 2; sh-indentation: 2; -*- vim:fenc=utf-8:et:sw=2:ts=2:sts=2
#
# Copyright (c) 2016 Enrico M. Crisostomo
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
setopt localoptions
setopt localtraps
unsetopt glob_subst

set -o errexit
set -o nounset

REQUIRED_PROGS=( xmlstarlet )
PROGNAME=$0

check_programs()
{
  for p in ${REQUIRED_PROGS}
  do
    command -v ${p} > /dev/null 2>&1 || {
      >&2 print -- Cannot find ${p}
      exit 1
    }
  done
}

print_usage()
{
  print -- "${PROGNAME}"
  print
  print -- "Usage:"
  print -- "${PROGNAME} repository"
  print
  print -- "Report bugs to <>."
}

# main
check_programs

while getopts ":h" opt
do
  case $opt in
    h)
      print_usage
      exit 0
      ;;
    \?)
      >&2 print -- Invalid option -${OPTARG}.
      exit 1
      ;;
    :)
      >&2 print -- Missing argument to -${OPTARG}.
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

(( $# == 1 )) || {
  >&2 print -- Invalid number of arguments
  exit 2
}

POM=${1}

if [[ -d ${POM} ]]
then
  POM=${POM}/pom.xml
fi

if [[ ! -e ${POM} ]]
then
  >&2 No such file or directory: ${POM}
  continue
fi

PARENT=$(xmlstarlet sel \
                    -N x=http://maven.apache.org/POM/4.0.0 \
                    -t -m "/x:project/x:version" \
                    -v . \
                    ${POM} || true)

printf "%s\n" ${PARENT}
