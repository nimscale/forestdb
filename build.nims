
#stand alone building of forestdb


# Start nimble section

version = "1.0"
author = "Nimscale"
description = "ForestDB bind for Nim."
license = "Apache Licence 2.0"

# End nimble section
import ospaths
import strutils

mode = ScriptMode.Verbose

try:                                  # as for me this section doesn't work
   requires "libsnappy-dev"
   requires "libaio-devel"
   requires "cmake"
   requires "git"
except:
   exec "sudo apt install cmake libaio-devel libsnappy-dev"

echo "Execute sudo apt install cmake libaio-devel libsnappy-dev"
exec "sudo apt-get update"
exec "sudo apt-get install cmake"
exec "sudo apt-get install libaio-dev"
exec "sudo apt-get install libsnappy-dev"

let
  dirName = "libforestdb"
  buildDir = "build"

if false == dirExists(dirName):
  exec "git clone https://github.com/couchbase/forestdb.git " & dirName

withDir dirName:
  exec "git checkout v1.2"                     # Get the latest stable release
  mkDir buildDir
  withDir buildDir:
    exec "cmake -DCMAKE_BUILD_TYPE=Debug ../"  # Change to Release in production
    exec "make all"



