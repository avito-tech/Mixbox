#  MixboxBuiltinIpc

A fully working prototype of implementation of MixboxIpc.
It will be used as a replacement for implementation based on SBTUITestTunnel.

# Motivation
- Launching application can be customized (ideally an IPC tool should not require XCUIApplication at all)
- Custom launching can be faster (up to 7-9 seconds faster for some app on macbook pro 2017)
- There is an issue in the upstream of SBTUITestTunnel that leads to bugs in WKWebView
- SBTUITestTunnel terminates an app after a timeout, which is not customizable
- There are lots of code that we don't use

DISCLAIMER: We appreciate the SBTUITestTunnel a lot and will recommend it for usage. It worked perfectly for more than 6 months, and we
are switching from it only due to the need of customization. It will be cheaper with our own product. We don't think our product will solve
the same issues better than SBTUITestTunnel, but it will solve our issues better.
