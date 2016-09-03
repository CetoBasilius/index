# index.*
### Overview
---
Lua module path shortener for *require* function. Any call to require will be intercepted and if normal require does not yield results, index will search for added paths for modules.
### Functions
---

- index.*addPath(**path1**, **path2**, **...**)*
    - Adds path to index. Multiple paths can be added as different parameters.
- index.*setNamespace(**newNamespace**)*
    - Will set the namespace to **newNamespace**. Adding this means that requires will ignore the namespace if found, on requires.
- index.*getRequirePath(**moduleName**)*
    - Will return the real, full require path, if the module has been loaded by index. Will return **moduleName** otherwise.

### Example usage
---
Supposing you have multiple libraries deep in folders:

- *"path.to.libs.numbers"*
- *"path.to.libs.strings"*

Simply do: `require("index")("path.to.libs")` and now you can require your libs `require("numbers")` and `require("strings")`.

Required modules will receive a table via `...` with the properties:

- *.name*: The real path where the module was found.
- *.path*: The path that was added by index.

### Notes
---

`require("index").addPath("path.to.libs")` and `require("index")("path.to.libs")` have the same effect. Call an aditional time to set a namespace.


---
Copyright (c) 2014-2016, Basilio Germán
All rights reserved.