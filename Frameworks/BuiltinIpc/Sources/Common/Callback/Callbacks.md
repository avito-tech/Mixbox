#  IpcCallback

It is an experimental type. It is like an inter-process closure.

See `IpcCallbacksTests` for usage.

It not inside MixboxIpc, because it relies on implementation.

It relies on `userInfo` field of `Encoder` or `Decoder` in methods of `Codable`, which contain references
to storage of closures (on server side) and `IpcClient`.

There are two ways of solving this:
1. Keep everything as is
2. Make custom Codable (so we will lose code generation built-in in Swift), where encoders/decoders will know about ipc client and server.
