# Lua-Feistel-Cipher
Simple Feistel cipher implemented in Lua

To use place ```feistel.lua``` in the same directory as your project, put this line at the top ```local feistel = require("feistel")``` of your own Lua file. 
The module can then be used with the dot syntax, for example
```feistel.encrypt(plaintext, key, rounds, blockSize)```
