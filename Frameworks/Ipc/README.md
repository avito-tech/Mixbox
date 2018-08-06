#  MixboxIpc

VERY simple abstraction for IPC.

Server protocol contains only one method (process data).
Client protocol contains only one method (send data).

Thus it is easy to implement, switch between implementations. If you use these protocols, you are protecting your code from being tightly coupled with some implementation.

However, it is hard to use it for everything (at the moment). E.g. it wouldn't suit for streaming / passing large files.