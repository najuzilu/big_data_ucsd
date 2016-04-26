#!/bin/bash

L=$HOME/tmp/lucene-5.5.0
CLASSPATH=${CLASSPATH}:$L/core/*:$L/queryparser/*:$L/analysis/common/*:$L/demo/*
export CLASSPATH

java LuceneTFIDF "$*"
