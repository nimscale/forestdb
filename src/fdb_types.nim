 {.deadCodeElim: on.}
when defined(windows):
  const
    libforestdb* = "libforestdb.dll"
elif defined(macosx):
  const
    libforestdb* = "libforestdb.dylib"
else:
  const
    libforestdb* = "libforestdb.so"
##  -*- Mode: C++; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-
##
##      Copyright 2010 Couchbase, Inc
##
##    Licensed under the Apache License, Version 2.0 (the "License");
##    you may not use this file except in compliance with the License.
##    You may obtain a copy of the License at
##
##        http://www.apache.org/licenses/LICENSE-2.0
##
##    Unless required by applicable law or agreed to in writing, software
##    distributed under the License is distributed on an "AS IS" BASIS,
##    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##    See the License for the specific language governing permissions and
##    limitations under the License.
##

##
## #ifndef _MSC_VER
## #include <stdbool.h>
## #else
## #ifndef __cplusplus
## #pragma once
## #define false (0)
## #define true (1)
## #define bool int
## #endif
## #endif
##
## *
##  Maximum key length supported.
##

const
  FDB_MAX_KEYLEN* = (65408)     ##  2^16 - 64*2 (64: max chunk size)
                         ## *
                         ##  Maximum metadata length supported.
                         ##
  FDB_MAX_METALEN* = (65535)    ##  2^16 - 1
                          ## *
                          ##  Maximum value length supported.
                          ##
  FDB_MAX_BODYLEN* = (4294967295'i64) ##  2^32 - 1

## *
##  Flags to be passed to fdb_open() API
##

type
  fdb_open_flags* = uint32

const ## *
     ##  Open a ForestDB file with read-write mode and
     ##  create a new empty ForestDB file if it doesn't exist.
     ##
  FDB_OPEN_FLAG_CREATE* = 1     ## *
                         ##  Open a ForestDB file in read only mode, but
                         ##  return an error if a file doesn't exist.
                         ##
  FDB_OPEN_FLAG_RDONLY* = 2 ## *
                         ##  Open a ForestDB file with legacy CRC.
                         ##
                         ##  This flag is intended to be used by upgrade tests.
                         ##
                         ##  This flag is only valid if the file to be opened is a new file or an
                         ##  existing file with legacy CRC.
                         ##
                         ##  Opening existing files which use CRC32C with this flag results
                         ##  in FDB_RESULT_INVALID_ARGS.
                         ##
  FDB_OPEN_WITH_LEGACY_CRC* = 4

## *
##  Options to be passed to fdb_commit() API.
##  Combinational options can be possible.
##

type
  fdb_commit_opt_t* = uint8

const                         ## *
     ##  Perform commit without any options.
     ##
  FDB_COMMIT_NORMAL* = 0x00000000 ## *
                               ##  Manually flush WAL entries even though it doesn't
                               ##  reach the configured threshold
                               ##
  FDB_COMMIT_MANUAL_WAL_FLUSH* = 0x00000001

## *
##  Flag to enable / disable a sequence btree.
##

type
  fdb_seqtree_opt_t* = uint8

const
  FDB_SEQTREE_NOT_USE* = 0
  FDB_SEQTREE_USE* = 1

## *
##  Durability options for ForestDB.
##

type
  fdb_durability_opt_t* = uint8

const                         ## *
     ##  Synchronous commit through OS page cache.
     ##
  FDB_DRB_NONE* = 0x00000000 ## *
                          ##  Synchronous commit through the direct IO option to bypass
                          ##  the OS page cache.
                          ##
  FDB_DRB_ODIRECT* = 0x00000001 ## *
                             ##  Asynchronous commit through OS page cache.
                             ##
  FDB_DRB_ASYNC* = 0x00000002 ## *
                           ##  Asynchronous commit through the direct IO option to bypass
                           ##  the OS page cache.
                           ##
  FDB_DRB_ODIRECT_ASYNC* = 0x00000003

## *
##  Options for compaction mode.
##

type
  fdb_compaction_mode_t* = uint8

const
  FDB_COMPACTION_MANUAL* = 0
  FDB_COMPACTION_AUTO* = 1

## *
##  Transaction isolation level.
##  Note that both serializable and repeatable-read isolation levels are not
##  supported at this moment. We plan to support them in the future releases.
##

type
  fdb_isolation_level_t* = uint8

const ##  FDB_ISOLATION_SERIALIZABLE = 0,
     ##  FDB_ISOLATION_REPEATABLE_READ = 1,
     ## *
     ##  Prevent a transaction from reading uncommitted data from other
     ##  transactions.
     ##
  FDB_ISOLATION_READ_COMMITTED* = 2 ## *
                                 ##  Allow a transaction to see uncommitted data from other transaction.
                                 ##
  FDB_ISOLATION_READ_UNCOMMITTED* = 3

## *
##  Pointer type definition of a customized compare function for fixed size key.
##

type
  fdb_custom_cmp_fixed* = proc (a: pointer; b: pointer): cint {.cdecl.}

## *
##  Pointer type definition of a customized compare function for variable length key.
##

type
  fdb_custom_cmp_variable* = proc (a: pointer; len_a: csize; b: pointer; len_b: csize): cint {.
      cdecl.}
  fdb_seqnum_t* = uint64

const
  FDB_SNAPSHOT_INMEM* = ((fdb_seqnum_t)(- 1))

## *
##  ForestDB doc structure definition
##

type
  fdb_doc* = object
    keylen*: csize             ## *
                 ##  key length.
                 ##
    ## *
    ##  metadata length.
    ##
    metalen*: csize            ## *
                  ##  doc body length.
                  ##
    bodylen*: csize            ## *
                  ##  actual doc size written on disk.
                  ##
    size_ondisk*: csize        ## *
                      ##  Pointer to doc's key.
                      ##
    key*: pointer              ## *
                ##  Sequence number assigned to a doc.
                ##
    seqnum*: fdb_seqnum_t ## *
                        ##  Offset to the doc (header + key + metadata + body) on disk.
                        ##
    offset*: uint64            ## *
                  ##  Pointer to doc's metadata.
                  ##
    meta*: pointer             ## *
                 ##  Pointer to doc's body.
                 ##
    body*: pointer             ## *
                 ##  Is a doc deleted?
                 ##
    deleted*: bool             ## *
                 ##  Flags for miscellaneous doc properties.
                 ##
    flags*: uint32 ## *
                 ##  Use the seqnum set by user instead of auto-generating.
                 ##


const
  FDB_CUSTOM_SEQNUM* = 0x00000001

## *
##  Opaque reference to a ForestDB file handle, which is exposed in public APIs.
##


type
  cstruct_fdb_file_handle {.importc: "struct _fdb_file_handle", final.} = object
  fdb_file_handle* =  ptr cstruct_fdb_file_handle



## *
##  Opaque reference to a ForestDB KV store handle, which is exposed in public APIs.
##

type
  cstruct_fdb_kvs_handle {.importc: "struct _fdb_kvs_handle", final.} = object
  fdb_kvs_handle* = ptr cstruct_fdb_kvs_handle

## *
##  Compaction status for callback function.
##

type
  fdb_compaction_status* = uint32

const
  FDB_CS_BEGIN* = 0x00000001
  FDB_CS_MOVE_DOC* = 0x00000002
  FDB_CS_BATCH_MOVE* = 0x00000004
  FDB_CS_FLUSH_WAL* = 0x00000008
  FDB_CS_END* = 0x00000010      ##  invoked at the end of every phase of compaction
  FDB_CS_COMPLETE* = 0x00000020

## *
##  Compaction decision returned if FDB_CS_MOVE_DOC callback option is used.
##  If this compaction callback option is used then it is upto its corresponding
##  callback function to specify, using the given return values below, if a
##  given document should be retained in the newly compacted file or dropped.
##

type
  fdb_compact_decision* = cint

const
  FDB_CS_KEEP_DOC* = 0x00000000
  FDB_CS_DROP_DOC* = 0x00000001

## *
##  Pointer type definition of a callback function for compaction.
##

type
  fdb_compaction_callback* = proc (fhandle: ptr fdb_file_handle;
                                status: fdb_compaction_status;
                                kv_store_name: cstring; doc: ptr fdb_doc;
                                last_oldfile_offset: uint64;
                                last_newfile_offset: uint64; ctx: pointer): fdb_compact_decision {.
      cdecl.}

## *
##  Encryption algorithms known to ForestDB.
##

type
  fdb_encryption_algorithm_t* = cint

const
  FDB_ENCRYPTION_NONE* = 0      ## *< No encryption (default)
  FDB_ENCRYPTION_AES256* = 1

## *
##  File encryption key.
##

type
  fdb_encryption_key* = object
    algorithm*: fdb_encryption_algorithm_t
    bytes*: array[32, uint8]


## *
##  ForestDB config options that are passed to fdb_open API.
##

type
  fdb_config* = object
    chunksize*: uint16 ## *
                     ##  Chunk size (bytes) that is used to build B+-tree at each level.
                     ##  It is set to 8 bytes by default and has a min value of 4 bytes
                     ##  and a max value of 64 bytes.
                     ##  This is a local config to each ForestDB file.
                     ##
    ## *
    ##  Size of block that is a unit of IO operations.
    ##  It is set to 4KB by default and has a min value of 1KB and a max value of
    ##  128KB. This is a global config that is used across all ForestDB files.
    ##
    blocksize*: uint32 ## *
                     ##  Buffer cache size in bytes. If the size is set to zero, then the buffer
                     ##  cache is disabled. This is a global config that is used across all
                     ##  ForestDB files.
                     ##
    buffercache_size*: uint64 ## *
                            ##  WAL index size threshold in memory (4096 entries by default).
                            ##  This is a local config to each ForestDB file.
                            ##
    wal_threshold*: uint64 ## *
                         ##  Flag to enable flushing the WAL whenever it reaches its threshold size.
                         ##  This reduces memory usage when a lot of data is written before a commit.
                         ##
    wal_flush_before_commit*: bool ## *
                                 ##  Flag to enable automatic commit.
                                 ##  This is a local config to each ForestDB file.
                                 ##
    auto_commit*: bool ## *
                     ##  Interval for purging logically deleted documents in the unit of second.
                     ##  It is set to 0 second (purge during next compaction) by default.
                     ##  This is a local config to each ForestDB file.
                     ##
    purging_interval*: uint32  ## *
                            ##  Flag to enable or disable a sequence B+-Tree.
                            ##  This is a local config to each ForestDB file.
                            ##
    seqtree_opt*: fdb_seqtree_opt_t ## *
                                  ##  Flag to enable synchronous or asynchronous commit options.
                                  ##  This is a local config to each ForestDB file.
                                  ##
    durability_opt*: fdb_durability_opt_t ## *
                                        ##  Flags for fdb_open API. It can be used for specifying read-only mode.
                                        ##  This is a local config to each ForestDB file.
                                        ##
    flags*: fdb_open_flags ## *
                         ##  Maximum size (bytes) of temporary buffer for compaction (4MB by default).
                         ##  This is a local config to each ForestDB file.
                         ##
    compaction_buf_maxsize*: uint32 ## *
                                  ##  Destroy all the cached blocks in the global buffer cache when a ForestDB
                                  ##  file is closed. It is set to true by default. This is a global config
                                  ##  that is used across all ForestDB files.
                                  ##
    cleanup_cache_onclose*: bool ## *
                               ##  Compress the body of document when it is written on disk. The compression
                               ##  is disabled by default. This is a global config that is used across all
                               ##  ForestDB files.
                               ##
    compress_document_body*: bool ## *
                                ##  Flag to enable auto compaction for the file. The auto compaction is disabled
                                ##  by default.
                                ##  This is a local config to each ForestDB file.
                                ##
    compaction_mode*: fdb_compaction_mode_t ## *
                                          ##  Compaction threshold in the unit of percentage (%). It can be calculated
                                          ##  as '(stale data size)/(total file size)'. The compaction daemon triggers
                                          ##  compaction if this threshold is satisfied.
                                          ##  Compaction will not be performed when this value is set to zero or 100.
                                          ##  This is a local config to each ForestDB file.
                                          ##
    compaction_threshold*: uint8 ## *
                               ##  The minimum filesize to perform compaction.
                               ##  This is a local config to each ForestDB file.
                               ##
    compaction_minimum_filesize*: uint64 ## *
                                       ##  Duration that the compaction daemon periodically wakes up, in the unit of
                                       ##  second. This is a global config that is used across all ForestDB files.
                                       ##
    compactor_sleep_duration*: uint64 ## *
                                    ##  Flag to enable supporting multiple KV instances in a DB instance.
                                    ##  This is a global config that is used across all ForestDB files.
                                    ##
    multi_kv_instances*: bool ## *
                            ##  Duration that prefetching of DB file will be performed when the file
                            ##  is opened, in the unit of second. If the duration is set to zero,
                            ##  prefetching is disabled. This is a local config to each ForestDB file.
                            ##
    prefetch_duration*: uint64 ## *
                             ##  Number of in-memory WAL index partitions for a DB file.
                             ##  This is a local config to each ForestDB file.
                             ##
    num_wal_partitions*: uint16 ## *
                              ##  Number of buffer cache partitions for each DB file.
                              ##  This is a local config to each ForestDB file.
                              ##
    num_bcache_partitions*: uint16 ## *
                                 ##  Callback function for compaction.
                                 ##  This is a local config to each ForestDB file.
                                 ##
    compaction_cb*: fdb_compaction_callback ## *
                                          ##  Mask to select when to invoke callback function during compaction.
                                          ##  Note that mask value is a combination of flags defined in
                                          ##  fdb_compaction_status.
                                          ##  This is a local config to each ForestDB file.
                                          ##
    compaction_cb_mask*: uint32 ## *
                              ##  Auxiliary data for compaction callback function.
                              ##  This is a local config to each ForestDB file.
                              ##
    compaction_cb_ctx*: pointer ## *
                              ##  Maximum probability (range: 20% ~ 100%) for the compactor to grab
                              ##  the writer's lock during each batch write in case the writer's throughput
                              ##  is faster than the compactor, to make sure that the compactor can keep
                              ##  pace with the writer and eventually complete the compaction.
                              ##  Note that we plan to reduce the compaction overhead significantly soon
                              ##  and deprecate this parameter when it is not needed anymore.
                              ##  This is a local config to each ForestDB file.
                              ##
    max_writer_lock_prob*: csize ## *
                               ##  Number of daemon compactor threads. It is set to 4 threads by default.
                               ##  If many files are opened and accessed concurrently, then it is
                               ##  recommended to increase this value if the host machine has enough cores
                               ##  and disk I/O bandwidth.
                               ##  This is a global config that is configured across all ForestDB files.
                               ##
    num_compactor_threads*: csize ## *
                                ##  Number of background flusher threads. It is set to 4 threads by default.
                                ##  For write intensive workloads with large commit intervals and many files
                                ##  it is recommended to increase this value if the host machine has enough
                                ##  cores and disk I/O bandwidth.
                                ##  This is a global config that is configured across all ForestDB files.
                                ##
    num_bgflusher_threads*: csize ## *
                                ##  Encryption key for the database. Default value has algorithm = FDB_ENCRYPTION_NONE,
                                ##  i.e. no encryption. When a database file is being created, its contents will be
                                ##  encrypted with the given key. When a database is re-opened, the same key
                                ##  must be given, otherwise fdb_open will fail with error FDB_RESULT_NO_DB_HEADERS.
                                ##
    encryption_key*: fdb_encryption_key

  fdb_kvs_config* = object
    create_if_missing*: bool ## *
                           ##  Flag to create a new empty KV store instance in a DB instance,
                           ##  if it doesn't exist.
                           ##
    ## *
    ##  Customized compare function for an KV store instance.
    ##
    custom_cmp*: fdb_custom_cmp_variable


## *
##  Pointer type definition of an error logging callback function.
##

type
  fdb_log_callback* = proc (err_code: cint; err_msg: cstring; ctx_data: pointer) {.cdecl.}

## *
##  Function pointer definition of the fatal error callback function.
##

type
  fdb_fatal_error_callback* = proc () {.cdecl.}

## *
##  ForestDB iterator options.Combinational options can be passed to the iterator.
##  For example, FDB_ITR_SKIP_MIN_KEY | FDB_ITR_SKIP_MAX_KEY means
##  "The smallest and largest keys in the iteration ragne won't be returned by the
##  iterator".
##

type
  fdb_iterator_opt_t* = uint16

const                         ## *
     ##  Return both key and value through iterator.
     ##
  FDB_ITR_NONE* = 0x00000000    ## *
                          ##  Return only non-deleted items through iterator.
                          ##
  FDB_ITR_NO_DELETES* = 0x00000002 ## *
                                ##  The lowest key specified will not be returned by the iterator.
                                ##
  FDB_ITR_SKIP_MIN_KEY* = 0x00000004 ## *
                                  ##  The highest key specified will not be returned by the iterator.
                                  ##
  FDB_ITR_SKIP_MAX_KEY* = 0x00000008

## *
##  ForestDB iterator seek options.
##

type
  fdb_iterator_seek_opt_t* = uint8

const ## *
     ##  If seek_key does not exist return the next sorted key higher than it.
     ##
  FDB_ITR_SEEK_HIGHER* = 0x00000000 ## *
                                 ##  If seek_key does not exist return the previous sorted key lower than it.
                                 ##
  FDB_ITR_SEEK_LOWER* = 0x00000001

## *
##  Opaque reference to ForestDB iterator structure definition, which is exposed
##  in public APIs.
##

type
  cstruct_fdb_iterator {.importc: "struct _fdb_iterator", final.} = object
  fdb_iterator* = cstruct_fdb_iterator

## *
##  Using off_t turned out to be a real challenge. On "unix-like" systems
##  its size is set by a combination of #defines like: _LARGE_FILE,
##  _FILE_OFFSET_BITS and/or _LARGEFILE_SOURCE etc. The interesting
##  part is however Windows.
##
##  Windows follows the LLP64 data model:
##  http://en.wikipedia.org/wiki/LLP64#64-bit_data_models
##
##  This means both the int and long int types have a size of 32 bits
##  regardless if it's a 32 or 64 bits Windows system.
##
##  And Windows defines the type off_t as being a signed long integer:
##  http://msdn.microsoft.com/en-us/library/323b6b3k.aspx
##
##  This means we can't use off_t on Windows if we deal with files
##  that can have a size of 2Gb or more.
##

type
  cs_off_t* = int64

## *
##  Information about a ForestDB file
##

type
  fdb_file_info* = object
    filename*: cstring         ## *
                     ##  A file name.
                     ##
    ## *
    ##  A new file name that is used after compaction.
    ##
    new_filename*: cstring ## *
                         ##  Total number of non-deleted documents aggregated across all KV stores.
                         ##
    doc_count*: uint64 ## *
                     ##  Total number of deleted documents aggregated across all KV stores.
                     ##
    deleted_count*: uint64     ## *
                         ##  Disk space actively used by the file.
                         ##
    space_used*: uint64 ## *
                      ##  Total disk space used by the file, including stale btree nodes and docs.
                      ##
    file_size*: uint64         ## *
                     ##  Number of KV store instances in a ForestDB file
                     ##
    num_kv_stores*: csize


## *
##  Information about a ForestDB KV store
##

type
  fdb_kvs_info* = object
    name*: cstring             ## *
                 ##  A KV store name.
                 ##
    ## *
    ##  Last sequence number assigned.
    ##
    last_seqnum*: fdb_seqnum_t ## *
                             ##  Total number of non-deleted documents in a KV store.
                             ##
    doc_count*: uint64         ## *
                     ##  Total number of deleted documents in a KV store.
                     ##
    deleted_count*: uint64     ## *
                         ##  Disk space actively used by the KV store.
                         ##
    space_used*: uint64        ## *
                      ##  File handle that owns the KV store.
                      ##
    file*: ptr fdb_file_handle


## *
##  Information about a ForestDB KV store's operational counters
##

type
  fdb_kvs_ops_info* = object
    num_sets*: uint64          ## *
                    ##  Number of fdb_set operations.
                    ##
    ## *
    ##  Number of fdb_del operations.
    ##
    num_dels*: uint64          ## *
                    ##  Number of fdb_commit operations.
                    ##
    num_commits*: uint64 ## *
                       ##  Number of fdb_compact operations on underlying file.
                       ##
    num_compacts*: uint64 ## *
                        ##  Number of fdb_get* (includes metaonly, byseq etc) operations.
                        ##
    num_gets*: uint64 ## *
                    ##  Number of fdb_iterator_get* (includes meta_only) operations.
                    ##
    num_iterator_gets*: uint64 ## *
                             ##  Number of fdb_iterator_moves (includes next,prev,seek) operations.
                             ##
    num_iterator_moves*: uint64


## *
##  Latency stat type for each public API
##

type
  fdb_latency_stat_type* = uint8

const
  FDB_LATENCY_SETS* = 0         ##  fdb_set API
  FDB_LATENCY_GETS* = 1         ##  fdb_get API
  FDB_LATENCY_COMMITS* = 2      ##  fdb_commit API
  FDB_LATENCY_SNAPSHOTS* = 3    ##  fdb_snapshot_open API
  FDB_LATENCY_COMPACTS* = 4

##  Number of latency stat types

const
  FDB_LATENCY_NUM_STATS* = 5

## *
##  Latency statistics of a specific ForestDB api call
##

type
  fdb_latency_stat* = object
    lat_count*: uint64         ## *
                     ##  Total number this call was invoked.
                     ##
    ## *
    ##  The fastest call took this amount of time in micro seconds.
    ##
    lat_min*: uint32 ## *
                   ##  The slowest call took this amount of time in micro seconds.
                   ##
    lat_max*: uint32 ## *
                   ##  The average time taken by this call in micro seconds.
                   ##
    lat_avg*: uint32


## *
##  List of ForestDB KV store names
##

type
  fdb_kvs_name_list* = object
    num_kvs_names*: csize      ## *
                        ##  Number of KV store names listed in kvs_names.
                        ##
    ## *
    ##  Pointer to array of KV store names.
    ##
    kvs_names*: cstringArray


## *
##  Persisted Snapshot Marker in file (Sequence number + KV Store name)
##

type
  fdb_kvs_commit_marker_t* = object
    kv_store_name*: cstring    ## *
                          ##  NULL-terminated KV Store name.
                          ##
    ## *
    ##  A Sequence number of the above KV store, which results from an
    ##  fdb_commit operation.
    ##
    seqnum*: fdb_seqnum_t


## *
##  An opaque file-level snapshot marker that can be used to purge
##  stale data up to a given file-level snapshot marker.
##

type
  fdb_snapshot_marker_t* = uint64

## *
##  Snapshot Information structure for a ForestDB database file.
##

type
  fdb_snapshot_info_t* = object
    marker*: fdb_snapshot_marker_t ## *
                                 ##  Opaque file-level snapshot marker that can be passed to
                                 ##  fdb_compact_upto() api.
                                 ##
    ## *
    ##  Number of KV store snapshot markers in the kvs_markers array.
    ##
    num_kvs_markers*: int64 ## *
                          ##  Pointer to an array of {kv_store_name, committed_seqnum} pairs.
                          ##
    kvs_markers*: ptr fdb_kvs_commit_marker_t

