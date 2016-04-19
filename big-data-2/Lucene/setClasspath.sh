#usage: . ./setClasspath.sh /your/path/to/lucenedirectory
#hint : do not put / in the end

CLASSPATH=${CLASSPATH}:$1/core/*:$1/queryparser/*:$1/analysis/common/*:$1/demo/*

export CLASSPATH
