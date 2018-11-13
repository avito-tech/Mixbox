#  Known Port Handshake

This setup is useful in a following scenario:

You have a process that can launch other process (example: test runner and tested app) and can pass data to a launched process.

Let it be SOURCE app and LAUNCHED app.

- SOURCE app is launched, it starts server
- SOURCE app launches LAUNCHED app and passes host & port (e.g. via environment or launch arguments)
- SOURCE app waits for handshake
- ----
- LAUNCHED app is launched, it starts server and creates client with received host & port
- LAUNCHED sends handshake (with server's host & port)
- ----
- SOURCE app receives handshake
- ????
- Both apps can send data to each other.

You would use KnownPortHandshakeWaiter for SOURCE app
You would use KnownPortHandshakeSender for LAUNCHED app
