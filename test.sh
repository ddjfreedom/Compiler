#!/bin/bash
BUILD_DIR="./build/Debug"
if [[ $# -eq 0 ]]; then
  #statements
  for file in testcases/*
  do
    echo "$file"
	  "$BUILD_DIR"/Compiler "$file"
  done
else
  "$BUILD_DIR"/Compiler $1
fi
exit 0

