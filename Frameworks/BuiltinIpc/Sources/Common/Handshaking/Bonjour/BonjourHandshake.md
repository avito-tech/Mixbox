#  Known Port Handshake

This setup is useful in a following scenario:

You have two processes that are launched independently of each other. One initiates making duplex connection, other is waiting.

Current limitations:
- It works only within localhost
- Running more than two processes is not supported and I don't know what will happen in that case.

Let one app be INITIATING app, other is WAITING app.

- WAITING app is launched, sets up bonjour service 
- ----
- INITIATING app is lunched, starts listening bonjour services
- INITIATING app finds WAITING app
- INITIATING app sends handshake
- ----
- WAITING app receives handshake
- ????
- Both apps can send data to each other.

You would use BonjourHandshakeSender for INITIATING app
You would use BonjourHandshakeWaiter for WAITING app
