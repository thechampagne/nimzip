# Copyright (c) 2023 XXIV
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, andor sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
const
  ZIP_DEFAULT_COMPRESSION_LEVEL* = 6 # Default zip compression level.
  ZIP_ENOINIT* = -1
  ZIP_EINVENTNAME* = -2
  ZIP_ENOENT* = -3
  ZIP_EINVMODE* = -4
  ZIP_EINVLVL* = -5
  ZIP_ENOSUP64* = -6
  ZIP_EMEMSET* = -7
  ZIP_EWRTENT* = -8
  ZIP_ETDEFLINIT* = -9
  ZIP_EINVIDX* = -10
  ZIP_ENOHDR* = -11
  ZIP_ETDEFLBUF* = -12
  ZIP_ECRTHDR* = -13
  ZIP_EWRTHDR* = -14
  ZIP_EWRTDIR* = -15
  ZIP_EOPNFILE* = -16
  ZIP_EINVENTTYPE* = -17
  ZIP_EMEMNOALLOC* = -18
  ZIP_ENOFILE* = -19
  ZIP_ENOPERM* = -20
  ZIP_EOOMEM* = -21
  ZIP_EINVZIPNAME* = -22
  ZIP_EMKDIR* = -23
  ZIP_ESYMLINK* = -24
  ZIP_ECLSZIP* = -25
  ZIP_ECAPSIZE* = -26
  ZIP_EFSEEK* = -27
  ZIP_EFREAD* = -28
  ZIP_EFWRITE* = -29
  ZIP_ERINIT* = -30
  ZIP_EWINIT* = -31
  ZIP_EWRINIT* = -32

type
  zip_t* {.bycopy.} = object

proc zip_strerror*(errnum: cint): cstring {.importc.}
  ##
  ##  Looks up the error message string corresponding to an error number.
  ##  @param errnum error number
  ##  @return error message string corresponding to errnum or NULL if error is not
  ##  found.
  ##
proc zip_open*(zipname: cstring, level: cint, mode: char): ptr zip_t {.importc.}
  ##
  ## Opens zip archive with compression level using the given mode.
  ##
  ## @param zipname zip archive file name.
  ## @param level compression level (0-9 are the standard zlib-style levels).
  ## @param mode file access mode.
  ##        - 'r': opens a file for reading/extracting (the file must exists).
  ##        - 'w': creates an empty file for writing.
  ##        - 'a': appends to an existing archive.
  ##
  ## @return the zip archive handler or NULL on error
  ##
proc zip_openwitherror*(zipname: cstring, level: cint, mode: char, errnum: ptr cint): ptr zip_t {.importc.}
  ##
  ##  Opens zip archive with compression level using the given mode.
  ##  The function additionally returns @param errnum -
  ##
  ##  @param zipname zip archive file name.
  ##  @param level compression level (0-9 are the standard zlib-style levels).
  ##  @param mode file access mode.
  ##         - 'r': opens a file for reading/extracting (the file must exists).
  ##         - 'w': creates an empty file for writing.
  ##         - 'a': appends to an existing archive.
  ##  @param errnum 0 on success, negative number (< 0) on error.
  ##
  ##  @return the zip archive handler or NULL on error
  ##
proc zip_close*(zip: ptr zip_t) {.importc.}
  ##
  ##  Closes the zip archive, releases resources - always finalize.
  ##
  ##  @param zip zip archive handler.
  ##
proc zip_is64*(zip: ptr zip_t): cint {.importc.}
  ##
  ##  Determines if the archive has a zip64 end of central directory headers.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the return code - 1 (true), 0 (false), negative number (< 0) on
  ##          error.
  ##
proc zip_entry_open*(zip: ptr zip_t, entryname: cstring): cint {.importc.}
  ##
  ##  Opens an entry by name in the zip archive.
  ##
  ##  For zip archive opened in 'w' or 'a' mode the function will append
  ##  a new entry. In readonly mode the function tries to locate the entry
  ##  in global dictionary.
  ##
  ##  @param zip zip archive handler.
  ##  @param entryname an entry name in local dictionary.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_opencasesensitive*(zip: ptr zip_t, entryname: cstring): cint {.importc.}
  ##
  ##  Opens an entry by name in the zip archive.
  ##
  ##  For zip archive opened in 'w' or 'a' mode the function will append
  ##  a new entry. In readonly mode the function tries to locate the entry
  ##  in global dictionary (case sensitive).
  ##
  ##  @param zip zip archive handler.
  ##  @param entryname an entry name in local dictionary (case sensitive).
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_openbyindex*(zip: ptr zip_t, index: csize_t): cint {.importc.}
  ##
  ##  Opens a new entry by index in the zip archive.
  ##
  ##  This function is only valid if zip archive was opened in 'r' (readonly) mode.
  ##
  ##  @param zip zip archive handler.
  ##  @param index index in local dictionary.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_close*(zip: ptr zip_t): cint {.importc.}
  ##
  ##  Closes a zip entry, flushes buffer and releases resources.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_name*(zip: ptr zip_t): cstring {.importc.}
  ##
  ##  Returns a local name of the current zip entry.
  ##
  ##  The main difference between user's entry name and local entry name
  ##  is optional relative path.
  ##  Following .ZIP File Format Specification - the path stored MUST not contain
  ##  a drive or device letter, or a leading slash.
  ##  All slashes MUST be forward slashes '/' as opposed to backwards slashes '\'
  ##  for compatibility with Amiga and UNIX file systems etc.
  ##
  ##  @param zip: zip archive handler.
  ##
  ##  @return the pointer to the current zip entry name, or NULL on error.
  ##
proc zip_entry_index*(zip: ptr zip_t): clonglong {.importc.}
  ##
  ##  Returns an index of the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the index on success, negative number (< 0) on error.
  ##
proc zip_entry_isdir*(zip: ptr zip_t): cint {.importc.}
  ##
  ##  Determines if the current zip entry is a directory entry.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the return code - 1 (true), 0 (false), negative number (< 0) on
  ##          error.
  ##
proc zip_entry_size*(zip: ptr zip_t): culonglong {.importc.}
  ##
  ##  Returns the uncompressed size of the current zip entry.
  ##  Alias for zip_entry_uncomp_size (for backward compatibility).
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the uncompressed size in bytes.
  ##
proc zip_entry_uncomp_size*(zip: ptr zip_t): culonglong {.importc.}
  ##
  ##  Returns the uncompressed size of the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the uncompressed size in bytes.
  ##
proc zip_entry_comp_size*(zip: ptr zip_t): culonglong {.importc.}
  ##
  ##  Returns the compressed size of the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the compressed size in bytes.
  ##
proc zip_entry_crc32*(zip: ptr zip_t): cuint {.importc.}
  ##
  ##  Returns CRC-32 checksum of the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the CRC-32 checksum.
  ##
proc zip_entry_write*(zip: ptr zip_t, buf: pointer, bufsize: csize_t): cint {.importc.}
  ##
  ##  Compresses an input buffer for the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##  @param buf input buffer.
  ##  @param bufsize input buffer size (in bytes).
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_fwrite*(zip: ptr zip_t, filename: cstring): cint {.importc.}
  ##
  ##  Compresses a file for the current zip entry.
  ##
  ##  @param zip zip archive handler.
  ##  @param filename input file.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_read*(zip: ptr zip_t, buf: ptr pointer, bufsize: ptr csize_t): clonglong {.importc.}
  ##
  ##  Extracts the current zip entry into output buffer.
  ##
  ##  The function allocates sufficient memory for a output buffer.
  ##
  ##  @param zip zip archive handler.
  ##  @param buf output buffer.
  ##  @param bufsize output buffer size (in bytes).
  ##
  ##  @note remember to release memory allocated for a output buffer.
  ##        for large entries, please take a look at zip_entry_extract function.
  ##
  ##  @return the return code - the number of bytes actually read on success.
  ##          Otherwise a negative number (< 0) on error.
  ##
proc zip_entry_noallocread*(zip: ptr zip_t, buf: pointer, bufsize: csize_t): clonglong {.importc.}
  ##
  ##  Extracts the current zip entry into a memory buffer using no memory
  ##  allocation.
  ##
  ##  @param zip zip archive handler.
  ##  @param buf preallocated output buffer.
  ##  @param bufsize output buffer size (in bytes).
  ##
  ##  @note ensure supplied output buffer is large enough.
  ##        zip_entry_size function (returns uncompressed size for the current
  ##        entry) can be handy to estimate how big buffer is needed.
  ##        For large entries, please take a look at zip_entry_extract function.
  ##
  ##  @return the return code - the number of bytes actually read on success.
  ##          Otherwise a negative number (< 0) on error (e.g. bufsize is not large
  ##  enough).
  ##
proc zip_entry_fread*(zip: ptr zip_t, filename: cstring): cint {.importc.}
  ##
  ##  Extracts the current zip entry into output file.
  ##
  ##  @param zip zip archive handler.
  ##  @param filename output file.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entry_extract*(zip: ptr zip_t, on_extract: proc (arg: pointer,
    offset: uint64, data: pointer, size: csize_t): csize_t {.cdecl.}, arg: pointer): cint {.importc.}
  ##
  ##  Extracts the current zip entry using a callback function (on_extract).
  ##
  ##  @param zip zip archive handler.
  ##  @param on_extract callback function.
  ##  @param arg opaque pointer (optional argument, which you can pass to the
  ##         on_extract callback)
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_entries_total*(zip: ptr zip_t): clonglong {.importc.}
  ##
  ##  Returns the number of all entries (files and directories) in the zip archive.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return the return code - the number of entries on success, negative number
  ##          (< 0) on error.
  ##
proc zip_entries_delete*(zip: ptr zip_t, entries: ptr cstring, len: csize_t): clonglong {.importc.}
  ##
  ##  Deletes zip archive entries.
  ##
  ##  @param zip zip archive handler.
  ##  @param entries array of zip archive entries to be deleted.
  ##  @param len the number of entries to be deleted.
  ##  @return the number of deleted entries, or negative number (< 0) on error.
  ##
proc zip_stream_extract*(stream: cstring, size: csize_t, dir: cstring, on_extract: proc (
    filename: cstring, arg: pointer): cint {.cdecl.}, arg: pointer): cint {.importc.}
  ##
  ##  Extracts a zip archive stream into directory.
  ##
  ##  If on_extract is not NULL, the callback will be called after
  ##  successfully extracted each zip entry.
  ##  Returning a negative value from the callback will cause abort and return an
  ##  error. The last argument (void *arg) is optional, which you can use to pass
  ##  data to the on_extract callback.
  ##
  ##  @param stream zip archive stream.
  ##  @param size stream size.
  ##  @param dir output directory.
  ##  @param on_extract on extract callback.
  ##  @param arg opaque pointer.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_stream_open*(stream: cstring, size: csize_t, level: cint, mode: char): ptr zip_t {.importc.}
  ##
  ##  Opens zip archive stream into memory.
  ##
  ##  @param stream zip archive stream.
  ##  @param size stream size.
  ##  @param level compression level (0-9 are the standard zlib-style levels).
  ##  @param mode file access mode.
  ##         - 'r': opens a file for reading/extracting (the file must exists).
  ##         - 'w': creates an empty file for writing.
  ##         - 'a': appends to an existing archive.
  ##
  ##  @return the zip archive handler or NULL on error
  ##
proc zip_stream_openwitherror*(stream: cstring, size: csize_t, level: cint, mode: char,
                              errnum: ptr cint): ptr zip_t {.importc.}
  ##
  ##  Opens zip archive stream into memory.
  ##  The function additionally returns @param errnum -
  ##
  ##  @param stream zip archive stream.
  ##  @param size stream size.*
  ##  @param level compression level (0-9 are the standard zlib-style levels).
  ##  @param mode file access mode.
  ##         - 'r': opens a file for reading/extracting (the file must exists).
  ##         - 'w': creates an empty file for writing.
  ##         - 'a': appends to an existing archive.
  ##  @param errnum 0 on success, negative number (< 0) on error.
  ##
  ##  @return the zip archive handler or NULL on error
  ##
proc zip_stream_copy*(zip: ptr zip_t, buf: ptr pointer, bufsize: ptr csize_t): clonglong {.importc.}
  ##
  ##  Copy zip archive stream output buffer.
  ##
  ##  @param zip zip archive handler.
  ##  @param buf output buffer. User should free buf.
  ##  @param bufsize output buffer size (in bytes).
  ##
  ##  @return copy size
  ##
proc zip_stream_close*(zip: ptr zip_t) {.importc.}
  ##
  ##  Close zip archive releases resources.
  ##
  ##  @param zip zip archive handler.
  ##
  ##  @return
  ##
proc zip_create*(zipname: cstring, filenames: ptr cstring, len: csize_t): cint {.importc.}
  ##
  ##  Creates a new archive and puts files into a single zip archive.
  ##
  ##  @param zipname zip archive file.
  ##  @param filenames input files.
  ##  @param len: number of input files.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
proc zip_extract*(zipname: cstring, dir: cstring, on_extract_entry: proc (
    filename: cstring, arg: pointer): cint {.cdecl.}, arg: pointer): cint {.importc.}
  ##
  ##  Extracts a zip archive file into directory.
  ##
  ##  If on_extract_entry is not NULL, the callback will be called after
  ##  successfully extracted each zip entry.
  ##  Returning a negative value from the callback will cause abort and return an
  ##  error. The last argument (void *arg) is optional, which you can use to pass
  ##  data to the on_extract_entry callback.
  ##
  ##  @param zipname zip archive file.
  ##  @param dir output directory.
  ##  @param on_extract_entry on extract callback.
  ##  @param arg opaque pointer.
  ##
  ##  @return the return code - 0 on success, negative number (< 0) on error.
  ##
