
#stand alone building of forestdb

# End nimble section
import ospaths
import strutils

mode = ScriptMode.Verbose

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
  if false == dirExists(buildDir):
    mkDir buildDir
  withDir buildDir:
    exec "cmake -DCMAKE_BUILD_TYPE=Debug ../"  # Change to Release in production
    exec "make all"



