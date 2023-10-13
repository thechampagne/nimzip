# nimzip

[![](https://img.shields.io/github/v/tag/thechampagne/nimzip?label=version)](https://github.com/thechampagne/nimzip/releases/latest) [![](https://img.shields.io/github/license/thechampagne/nimzip)](https://github.com/thechampagne/nimzip/blob/main/LICENSE)

Nim binding for a portable, simple **zip** library.

### Download

```
nimble install nimzip
```

### Example
```nim
import nimzip

when isMainModule:
  var zip = zip_open("/tmp/nim.zip", 6, 'w')
      
  discard zip_entry_open(zip, "test")
      
  let content: cstring = "test content"
  discard zip_entry_write(zip, content, csize_t(len(content)))

  discard zip_entry_close(zip)
  zip_close(zip)
```

### References
 - [zip](https://github.com/kuba--/zip)

### License

This repo is released under the [MIT License](https://github.com/thechampagne/nimzip/blob/main/LICENSE).
