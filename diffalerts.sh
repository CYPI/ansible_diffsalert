#!/bin/bash
scriptdir=$(readlink -m $(dirname $0))
diffdir="$scriptdir/../diffs"
source $scriptdir/../../ansible/bin/activate
cd $scriptdir/../
git pull origin master
make prod_compare_slow
for f in "$diffdir"/*; do
  if [ -f "$f" ] ; then # if there are no diffs $f is the diff dir; ignore this
    filename="${f##*/}"
    onlyname="${filename%.*}"
    pblink=$(less $f | $scriptdir/pastebinit -u svc-engservices2 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")
    nodebot corpeng-pages $onlyname "doesn't match Ansible Master" $pblink
  fi
done
