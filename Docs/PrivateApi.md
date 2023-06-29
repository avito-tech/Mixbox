# How-To Private API

We used class-dump to generate headers for frameworks, we used disassembler to reveal behavior of proprietary code and also some signatures of C-functions (class-dump works only for Obj-C).

Pure class-dump is not enough to make good headers, we have a script `dump.py` that generates headers of XCTest and patches output of class-dump. It can be used when new Xcode is released and there are changes in APIs. Currently multiple Xcode versions are supported.

## Check if anyone already solved the problem

There is a list of open-sourced projects for iOS UI testing, ordered by how much we used from them

- [EarlGrey](https://github.com/google/EarlGrey)
	- Visibility check
	- Run loop / waiting utils
	- Touch injection
- [Detox](https://github.com/wix/Detox/tree/master/detox/ios)
	- [Idea to use TCC.db for setting up application permissions.](https://github.com/wix/Detox/blob/016adbb6ec37235b17c4d036fe221daa454d22d1/detox/ios/DetoxHelper/DetoxHelper/Extension/JP/JPSimulatorHacks.m#L72) 
- [KIF](https://github.com/kif-framework/KIF/tree/master/Classes)
	- [Idea to use UIKeyboardImpl](https://github.com/kif-framework/KIF/blob/master/Classes/KIFTypist.m)
- [WebDriverAgent](https://github.com/facebookarchive/WebDriverAgent)
	- Private headers, long time ago
- [monkeytalk](https://github.com/alexnauda/monkeytalk/tree/master/monkeytalk-agent-ios)
	- We got nothing from it yet
- [WebKit](https://github.com/WebKit/webkit)
   - [Proper generation of IOHID events](https://github.com/WebKit/webkit/blob/master/Tools/WebKitTestRunner/ios/HIDEventGenerator.mm)
- [AppleSimUtils](https://github.com/wix/AppleSimulatorUtils/tree/master/applesimutils/applesimutils)
   - Interesting project. We may use it to improve stability of setting permissions.

## Table of contents

- [DumpPy.md](PrivateApi/DumpPy.md)
- [ClassDump.md](PrivateApi/ClassDump.md)
- [Disassembling.md](PrivateApi/Disassembling.md)
- [Runtime.md](PrivateApi/Runtime.md)
- [ExploringSimulator.md](PrivateApi/ExploringSimulator.md)
- [Examples.md](PrivateApi/Examples.md)
    - [FixingInjectionOfEventsExample.md](PrivateApi/FixingInjectionOfEventsExample.md)
