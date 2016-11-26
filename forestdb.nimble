#Package

version       = "1.2"
author        = "Nimscale"
description   = "ForestDB bind for Nim."
license       = "Apache Licence 2.0"

srcDir = "src"
bin = @["forestdb"]

# Dependencies

requires "nim >= 0.15.3"

task build, "Building forestdb!":
  setCommand "nim e build.nims"
  #exec "nim e build.nims"

