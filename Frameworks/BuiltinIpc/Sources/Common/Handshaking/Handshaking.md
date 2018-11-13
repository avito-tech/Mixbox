#  Handshaking

This code is used to establish duplex connection between two processes.

Currently there are two implemented setups for your IPC:

- When you can pass host & port from one process to another (`KnownPort`), e.g. when launching app you can pass it via environment or launch arguments.

- When you can not pass host & port from one process to another (`Bonjour`)

## Evolution

We really can go with a single implementation that uses Bonjour. It adds no overhead and it works well on both OSX and iOS (not sure about other Apple platforms such as watchOS or tvOS).
