#prints the schema of a json file
# usage: python json_schema.py jsonfilename

import sys
import json

filename = sys.argv[1]
data = []

try:
    with open(filename) as fname:
    	data.append(json.load(fname))
except Exception:
    print "Error while reading file: ", filename
    print "Check if the file complies with JSON format"
    print "\nUsage: python json_schema.py jsonfilename"
    sys.exit()

def dfs_inner(x, indent):
    try:
        for key, value in x.iteritems():
            print indent + key
            try:
                dfs_inner(value, indent+"....")
            except Exception:
                pass
    except Exception:
        pass

#outer dfs
indent = " "
for key, value in data[0].iteritems():
    print key
    dfs_inner(value, indent+"....")