#!/bin/bash
# shell script goes here
for file in ${SRCROOT}/testcases/*
do
	${TARGET_BUILD_DIR}/Compiler "$file"
done
exit 0
