##
##  Base example
##
##  ForestDB wrapper base example.
##

import
  macros,
  unittest,
  strutils,
  ../src/forestdb,
  ../src/fdb_errors,
  ../src/fdb_types

##
##  The basic tests suite.
##
suite "Basic tests." :
  ##
  ##  Forest DB initial test.
  ##
  test "Forest DB init test." :
    var
      r : int = 0
      status : fdb_status
      dbfile : ptr fdb_file_handle
      db : ptr fdb_kvs_handle
      fconfig : fdb_config = fdb_get_default_config()
      kvs_config : fdb_kvs_config = fdb_get_default_kvs_config()

    status = fdb_init(addr fconfig)
    check(status == FDB_RESULT_SUCCESS)

    status = fdb_open(addr dbfile, "../dummy1", addr fconfig)
    check(status == FDB_RESULT_SUCCESS)

    status = fdb_kvs_open_default(dbfile, addr db, addr kvs_config)
    check(status == FDB_RESULT_SUCCESS)

    status = fdb_close(dbfile)
    check(status == FDB_RESULT_SUCCESS)
    status = fdb_shutdown()
    check(status == FDB_RESULT_SUCCESS)

