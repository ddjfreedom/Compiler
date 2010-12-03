#!/bin/bash
cd ${SRCROOT}
rm -f parse.tab.h parse.tab.m lex.yy.m
bison --defines=parse.tab.h -o parse.tab.m -v parse.y
flex -o lex.yy.m lexical.l

