# trie.fennel

Store lists (Lua sequential tables) in a [trie][]. This is a Fennel and Lua *toy* library.

This library associates a “path” in the trie (which is just a Lua sequential table) with a value.

> *Note*: using a native Lua table is likely much more efficient in nearly every scenario, due to the overhead of maintaing the trie nodes.

[trie]: https://en.wikipedia.org/wiki/Trie
