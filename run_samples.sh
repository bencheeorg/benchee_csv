#! /bin/bash

set -e

for sample in samples/*
do
  if ! [ -d "$sample" ]; then
    echo "running $sample"
    echo ""
    mix run "$sample"
    echo ""
    echo "------------------------------------------"
    echo ""
  fi
done
