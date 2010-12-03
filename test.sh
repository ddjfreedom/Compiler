#!/bin/bash
BUILD_DIR="./build/Debug"
for file in testcases/*
do
	"$BUILD_DIR"/Compiler "$file"
done
exit 0

