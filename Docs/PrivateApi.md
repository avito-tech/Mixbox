# How-To Private API

We used class-dump to generate headers for frameworks, we used disassembler to reveal behavior of proprietary code and also some signatures of C-functions (class-dump works only for Obj-C).

Pure class-dump is not enough to make good headers, we have a script `dump.py` that generates headers of XCTest and patches output of class-dump. It can be used when new Xcode is released and there are changes in APIs. Currently multiple XCode versions are supported.

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

## class-dump

Install:

`brew install classdump`

Location of framework by its name (sorted):

```
find /Applications/Xcode.app -type d -name "*.framework"|grep -E "framework$"|perl -pe 's/(^.*?\/)([^\/]+?)(\.framework)/\2: \1\2\3/'|sort
```

Location of specific framework by its name (sorted):
```
find /Applications/Xcode.app -type d -name "*.framework"|grep "XCTest"
```

Here are ready to use shell one-liners that are store headers to some folder (`~/src/Headers/` in examples)

- XCTest, Xcode 9/10:

```
class-dump -o ~/src/Headers/XC10/XCTest -H /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework
```

## class-dump alternative for C code

Didn't find one, because I didn't have to. We use simulation of hardware keyboard via private API of IOKit (see `IOHIDEventCreateKeyboardEvent` in code).

I've just searched it on the Internet. It can help too.

## Disassembling

I personally use Hopper Disassembler to disassemble code. It had free plan.

It can generate human readable code like this:

```
/* @class XCUICoordinate */
-(void)pressForDuration:(double)arg2 {
    var_28 = intrinsic_movsd(var_28, arg2);
    r14 = [[NSString stringWithFormat:@"Long press %@", self] retain];
    rbx = [[self referencedElement] retain];
    var_58 = *__NSConcreteStackBlock;
    *(&var_58 + 0x8) = 0xffffffffc2000000;
    *(&var_58 + 0x10) = ___62-[XCUICoordinate(XCUICoordinateTouchEvents) pressForDuration:]_block_invoke;
    *(&var_58 + 0x18) = ___block_descriptor_tmp.94;
    *(&var_58 + 0x20) = self;
    *(&var_58 + 0x28) = intrinsic_movsd(*(&var_58 + 0x28), intrinsic_movsd(arg2, var_28));
    [rbx _dispatchEvent:r14 block:&var_58];
    [rbx release];
    [r14 release];
    return;
}
```

```
float ___62-[XCUICoordinate(XCUICoordinateTouchEvents) pressForDuration:]_block_invoke(int arg0, int arg1, int arg2) {
    r14 = [arg2 retain];
    r15 = [[XCEventGenerator sharedGenerator] retain];
    [*(arg0 + 0x20) screenPoint];
    var_30 = intrinsic_movsd(var_30, xmm0);
    var_40 = intrinsic_movsd(var_40, xmm1);
    xmm0 = intrinsic_movsd(xmm0, *(arg0 + 0x28));
    var_38 = intrinsic_movsd(var_38, xmm0);
    rbx = [[*(arg0 + 0x20) referencedElement] retain];
    [rbx interfaceOrientation];
    intrinsic_movsd(xmm0, var_30);
    intrinsic_movsd(xmm1, var_40);
    intrinsic_movsd(xmm2, var_38);
    [r15 pressAtPoint:rax forDuration:r14 orientation:r8 handler:r9];
    var_30 = intrinsic_movsd(var_30, xmm0);
    [r14 release];
    [rbx release];
    [r15 release];
    xmm0 = intrinsic_movsd(xmm0, var_30);
    return xmm0;
}
```

Why would you use it? Sometimes you can't just call a private function, you have to set up state and it can be sophisticated. With disassembler you can see what Apple did and do the same.

In the example we can see how to use XCEventGenerator to make custom swipes for UI tests. We **have to** wrap it inside `_dispatchEvent:block:` and return proper value from the block (otherwise it will not work properly).

This is an (almost) real example. And in that case reading disassembled code was not enough, I used debugger to figure out block type (see `Runtime`) and return value (because that was much bigger function for swipe, not for tap as in the example and the code was too hard for me to understand without debugger).

## Runtime

### Useful lldb shortcuts

- All methods and properties of an object (example is shortened, every NSObject contains thousands of methods):

```
(lldb) po [[NSObject new] _methodDescription]
<NSObject: 0x6000006757e0>:
in NSObject:
	Class Methods:
		+ (Class) safeCategoryBaseClass; (0x128e4541f)
		+ (void) _accessibilityCalDetailStringForEvent:(id)arg1 inLine1:(id*)arg2 inLine2:(id*)arg3 inLine3:(id*)arg4 inLine4:(id*)arg5; (0x129f8f3eb)
	Properties:
		@property (readonly, nonatomic) NSString* _atvaccessibilityITMLAccessibilityContent;
		@property (readonly) unsigned long hash;
	Instance Methods:
		- (id) _accessibilityParentForSubview:(id)arg1; (0x12b9f6a18)
		- (BOOL) _accessibilityIsTextInput; (0x128e45440)
		- (id) _accessibilityQuickSpeakTokenizer; (0x128e45438)
```

- Get signature of Objective-C block (with `0x7ffee671d3b0` address in the example):

```
(lldb) po long address = 0x7ffee671d3b0; struct BlockDescriptor { unsigned long reserved; unsigned long size; void *rest[1]; }; struct Block { void *isa; int flags; int reserved; void *invoke; struct BlockDescriptor *descriptor; }; struct Block *block = (struct Block *)address; struct BlockDescriptor *descriptor = block->descriptor; int copyDisposeFlag = 1 << 25; int signatureFlag = 1 << 30; int index = 0; if (block->flags & copyDisposeFlag) { index += 2; }; [NSString stringWithCString:(char *)descriptor->rest[index]];

d24@?0@"XCElementSnapshot"8@?<v@?@"XCSynthesizedEventRecord"@"NSError">16
```

- Same with `NSMethodSignature`:

```
(lldb) po long address = 0x7ffee671d3b0; struct BlockDescriptor { unsigned long reserved; unsigned long size; void *rest[1]; }; struct Block { void *isa; int flags; int reserved; void *invoke; struct BlockDescriptor *descriptor; }; struct Block *block = (struct Block *)address; struct BlockDescriptor *descriptor = block->descriptor; int copyDisposeFlag = 1 << 25; int signatureFlag = 1 << 30; int index = 0; if (block->flags & copyDisposeFlag) { index += 2; }; [NSMethodSignature signatureWithObjCTypes:(char *)descriptor->rest[index]];

<NSMethodSignature: 0x600001192400>
    number of arguments = 3
    frame size = 224
    is special struct return? NO
    return value: -------- -------- -------- --------
        type encoding (d) 'd'
        flags {isFloat}
        modifiers {}
        frame {offset = 16, offset adjust = 0, size = 16, size adjust = -8}
        memory {offset = 0, size = 8}
    argument 0: -------- -------- -------- --------
        type encoding (@) '@?'
        flags {isObject, isBlock}
        modifiers {}
        frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
        memory {offset = 0, size = 8}
    argument 1: -------- -------- -------- --------
        type encoding (@) '@"XCElementSnapshot"'
        flags {isObject}
        modifiers {}
        frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
        memory {offset = 0, size = 8}
            class 'XCElementSnapshot'
    argument 2: -------- -------- -------- --------
        type encoding (@) '@?<v@?@"XCSynthesizedEventRecord"@"NSError">'
        flags {isObject, isBlock}
        modifiers {}
        frame {offset = 16, offset adjust = 0, size = 8, size adjust = 0}
        memory {offset = 0, size = 8}
            type encoding (v) 'v'
            flags {}
            modifiers {}
            frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
            memory {offset = 0, size = 0}
            type encoding (@) '@?'
            flags {isObject, isBlock}
            modifiers {}
            frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
            memory {offset = 0, size = 8}
            type encoding (@) '@"XCSynthesizedEventRecord"'
            flags {isObject}
            modifiers {}
            frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
            memory {offset = 8, size = 8}
                class 'XCSynthesizedEventRecord'
            type encoding (@) '@"NSError"'
            flags {isObject}
            modifiers {}
            frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
            memory {offset = 16, size = 8}
                class 'NSError'
```

### Swizzling

Useful for reverse engineer arguments and return values of functions, especially Obj-C blocks.

Example: we need to determine block type and behavior. We swizzle the method:

```
extension XCUIElement {
    @objc func s_dispatchEvent(name: NSString?, block: NSObject) {
        s_dispatchEvent(name: name, block: block)
    }
}
```

We can set breakpoint and obtain block signature (see `Useful lldb shortcuts`).

Then we want to determine values of arguments and return type:

```
extension XCUIElement {
    @objc func s_dispatchEvent(name: NSString?, block: (XCElementSnapshot, () -> ()) -> Double) {
        s_dispatchEvent(name: name, block: block)
    }
}
```

Finally we get this:

```
extension XCUIElement {
    @objc func s_dispatchEvent(name: NSString?, block: @escaping (XCElementSnapshot?, (XCSynthesizedEventRecord?, NSError?) -> ()) -> Double) {
        s_dispatchEvent(name: name, block: { snapshot, handler in
            print("snapshot: \(snapshot)")
            print("handler: \(handler)")
            
            let result = block(snapshot, { eventRecord, error in
                print("eventRecord: \(eventRecord)")
                print("error: \(error)")
                
                handler(eventRecord, error)
            })
            
            print("result: \(result)")
            
            return result
        })
    }
}
```

Output:

```
snapshot: Optional(Application, 0x6000037d6080, pid: 1646, label: 'Tests')
handler: (Function)
result: 31.0
eventRecord: Optional(
<XCSynthesizedEventRecord:0x600000ca2460 name:'long press'> paths:
Path 1:
	<XCPointerEvent:0x60000173a7c0 type:1 coordinate:(207,448) pressure:0.0000 offset:0.00s>
	<XCPointerEvent:0x60000173a840 type:3 coordinate:(207,448) pressure:0.0000 offset:1.00s>)
error: nil
    t =    32.41s         Wait for mixbox.XcuiTests.app to idle
```

An educated guess was to pass handler right to one of XCEventGenerator functions, because types were matching. And it worked:

```
XCUIApplication()._dispatchEvent(actionName, block: { snapshot, handler in
    return actionClosure(xcEventGenerator) { record, error in
        handler?(record, error)
    }
})
```

## Examples

This section contains real life examples of how it is done. I missed this kind of example even when I already had some experience in the field. It can be helpful.

### Fixing injection of events

This is a raw log that describes thought process, tools and techniques that were used:

- Discovered a bug when was updating project to support 13: `SetTestActionSetsTextProperlyTests` was failing.
- Wrote a test of injecting IOHID events (`KeyboardEventInjectorImplTests`).
- The cause of bug with text is somewhere inside `KeyboardEventInjectorImpl`.
- I set breakpoints in `-[UIApplication handleKeyHIDEvent:]`
- The function was called as expected.
- Started debugging a sample app (not in a test mode) running in a simulator.
- Pressed some keys on hardware keyboard. The same method was called `handleKeyHIDEvent:`.
- Opened `UIKitCore` in Hopper (disassembler) `/Applications/Xcode_11_1.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/UIKitCore.framework`
- At this moment I already wasted a lot of time and started to write this log.
- Felt hopelessness. Thought about using private API of UIKeyboardImpl? But it is a wrong idea, because I'll have to not only recreate the exact logic of `-[UIApplication handleKeyUIEvent:]`, but also to support it in the future. The less private logic is used the better.
- Opened `-[UIApplication handleKeyUIEvent:]` in Hopper:

```
/* @class UIApplication */
-(void)handleKeyHIDEvent:(struct __IOHIDEvent *)arg2 {
    r14 = arg2;
    CFRetain(arg2);
    var_38 = self;
    rbx = [[self _responderForKeyEvents] retain];
    rax = GSEventGetHardwareKeyboardType();
    rax = rax & 0xff;
    var_40 = rbx;
    if (*(int32_t *)_handleKeyHIDEvent:.lastSeenType == rax) {
            rbx = 0x0;
    }
    else {
            *(int32_t *)_handleKeyHIDEvent:.lastSeenType = rax;
            rbx = 0x1;
    }
    r15 = [*(var_38->_eventDispatcher + 0x8) _physicalKeyboardEventForHIDEvent:r14];
    rax = [var_38 GSKeyboardForHWLayout:0x0 forceRebuild:rbx & 0xff];
    rdx = r14;
    rcx = rax;
    [r15 _setHIDEvent:rdx keyboard:rcx];
    var_30 = r15;
    rax = [r15 _isGlobeKey];
    r15 = var_40;
    if (rax != 0x0) {
            rax = [UIKeyboardImpl sharedInstance];
            rax = [rax retain];
            r12 = [rax handleKeyCommand:var_30 repeatOkay:0x0 beforePublicKeyCommands:0x1];
            [rax release];
            if (r12 != 0x0) {
                    CFRelease(r14);
            }
            else {
                    rax = [var_30 _isKeyDown];
                    rdi = var_38->_physicalKeycodeMap;
                    if (rax != 0x0) {
                            rsi = @selector(addObject:);
                    }
                    else {
                            rsi = @selector(removeObject:);
                    }
                    (*_objc_msgSend)(rdi, rsi);
                    CFRelease(r14);
                    rax = [r15 _keyCommandForEvent:var_30];
                    rax = [rax retain];
                    r12 = rax;
                    if ((rax != 0x0) && ([r12 _buttonType] != 0xffffffffffffffff)) {
                            rbx = *_objc_msgSend;
                            r13 = [[UIPressInfo alloc] init];
                            r14 = rbx;
                            [r13 setType:[r12 _buttonType]];
                            if ([var_30 _isKeyDown] != 0x0) {
                                    intrinsic_movsd(xmm0, *0x102a288);
                            }
                            (r14)(r13, @selector(setForce:));
                            rax = (r14)(var_30, @selector(_isKeyDown));
                            (r14)(r13, @selector(setPhase:), ((rax ^ 0x1) & 0xff) + ((rax ^ 0x1) & 0xff) * 0x2);
                            (r14)(var_30, @selector(timestamp));
                            (r14)(r13, @selector(setTimestamp:));
                            (r14)(r13, @selector(setSource:), 0x1);
                            (r14)(r13, @selector(setContextID:), BKSHIDEventGetContextIDFromEvent((r14)(var_30, @selector(_hidEvent))));
                            (r14)(*_UIApp, @selector(_prepareButtonEvent:withPressInfo:), var_30, r13);
                            (r14)(var_38, @selector(sendEvent:), var_30);
                            (r14)(var_38, @selector(_finishButtonEvent:), var_30);
                            [r13 release];
                    }
                    [var_38 handleKeyUIEvent:var_30];
                    [r12 release];
                    r15 = var_40;
            }
    }
    else {
            rax = [var_30 _isKeyDown];
            rdi = var_38->_physicalKeycodeMap;
            if (rax != 0x0) {
                    rsi = @selector(addObject:);
            }
            else {
                    rsi = @selector(removeObject:);
            }
            (*_objc_msgSend)(rdi, rsi);
            CFRelease(r14);
            rax = [r15 _keyCommandForEvent:var_30];
            rax = [rax retain];
            r12 = rax;
            if ((rax != 0x0) && ([r12 _buttonType] != 0xffffffffffffffff)) {
                    rbx = *_objc_msgSend;
                    r13 = [[UIPressInfo alloc] init];
                    r14 = rbx;
                    [r13 setType:[r12 _buttonType]];
                    if ([var_30 _isKeyDown] != 0x0) {
                            intrinsic_movsd(xmm0, *0x102a288);
                    }
                    (r14)(r13, @selector(setForce:));
                    rax = (r14)(var_30, @selector(_isKeyDown));
                    (r14)(r13, @selector(setPhase:), ((rax ^ 0x1) & 0xff) + ((rax ^ 0x1) & 0xff) * 0x2);
                    (r14)(var_30, @selector(timestamp));
                    (r14)(r13, @selector(setTimestamp:));
                    (r14)(r13, @selector(setSource:), 0x1);
                    (r14)(r13, @selector(setContextID:), BKSHIDEventGetContextIDFromEvent((r14)(var_30, @selector(_hidEvent))));
                    (r14)(*_UIApp, @selector(_prepareButtonEvent:withPressInfo:), var_30, r13);
                    (r14)(var_38, @selector(sendEvent:), var_30);
                    (r14)(var_38, @selector(_finishButtonEvent:), var_30);
                    [r13 release];
            }
            [var_38 handleKeyUIEvent:var_30];
            [r12 release];
            r15 = var_40;
    }
    [r15 release];
    return;
}

```

- Spotted this line `[rax handleKeyCommand:var_30 repeatOkay:0x0 beforePublicKeyCommands:0x1]`
- It was called in sample app, but not called if events were injected.
- I'm trying to find the `if`, that evaluates differently in those two cases.
- It is probably this `if`: `if (rax != 0x0) {`
- Started debugging `-[UIApplication handleKeyUIEvent:]` (I was using symbolic breakpoints).
- `rax = [r15 _isGlobeKey]`
- `r15 = [*(var_38->_eventDispatcher + 0x8) _physicalKeyboardEventForHIDEvent:r14]`
- So I need to see what is inside `r14`:

    ```
    Printing description of $r14:
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Timestamp:           122221775156402
    Total Latency:       10974528 us
    SenderID:            0x0000000000000000
    BuiltIn:             0
    ValueType:           Absolute
    EventType:           Keyboard
    Flags:               0x1
    UsagePage:           7
    Usage:               4
    Down:                1
    PressCount:          1
    LongPress:           no
    ClickSpeed:          0
    Phase:               
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ```
    
- `_physicalKeyboardEventForHIDEvent` in Hopper:

    ```
    /* @class UIEventEnvironment */
    -(void *)_physicalKeyboardEventForHIDEvent:(struct __IOHIDEvent *)arg2 {
    ```

- So I have to find a member `_eventDispatcher` of type `UIEventEnvironment` in `UIApplication`
- I found a register (randomly) with UIApplication and called `_methodDescription` to see its members.

    ```
    Printing description of $rdi:
    <UIApplication: 0x7fd88ad032f0>
    (lldb) po [0x7fd88ad032f0 _methodDescription]
    <UIApplication: 0x7fd88ad032f0>:
    in UIApplication:
    	Class Methods:
    		+ (Class) safeCategoryBaseClass; (0x108f2a573)
    		+ (BOOL) _isSerializableAccessibilityElement; (0x108f2ac80)
    <...and lots of text...>
    ```
    
- There is neither `_eventDispatcher` nor `eventDispatcher`
- `r15 = [*(var_38->_eventDispatcher + 0x8) _physicalKeyboardEventForHIDEvent:r14];` returns `UIPhysicalKeyboardEvent`, because `_setHIDEvent:keyboard:` is used later in code and it is implemented only in `UIPhysicalKeyboardEvent`
- Setting breakpoint in `-[UIPhysicalKeyboardEvent _setHIDEvent:keyboard:]`...
- The app didn't stop at breakpoint
- But `-[UIEventEnvironment _physicalKeyboardEventForHIDEvent:]` have been executed.
- Perhaps it is returning `nil`.
- So I got a register with `self` of type `UIEventEnvironment` (randomly found it):

    ```
    Printing description of $rdi:
    <UIEventEnvironment: 0x60000354c180>
    ```
- Executed this:
    ```
    (lldb) po [0x60000354c180 _physicalKeyboardEventForHIDEvent:0x0000600002b53640]
     nil
    ```
- **Everything is right! Case solved.**
- Inspecting what real event looks like (real means from real keyboard):

    ```
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Timestamp:           123849542723129
    Total Latency:       7336915 us
    [1mSenderID:            0x0ACEFADE00000004 NON KERNEL SENDER
    [0mBuiltIn:             0
    AttributeDataLength: 48
    AttributeData:       01 00 00 00 20 00 00 00 0a 0f 0a 0d 6b 65 79 62 6f 61 72 64 46 6f 63 75 73 12 02 10 01 1a 05 08 c1 b1 f8 69 20 02 28 00 00 00 00 00 00 00 00 00 
    ValueType:           Absolute
    EventType:           Keyboard
    Flags:               0x1
    UsagePage:           7
    Usage:               4
    Down:                1
    PressCount:          1
    LongPress:           no
    ClickSpeed:          0
    Phase:               
    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ```
    
- Diff:

    This doesn't work (injected event):
    
    ```
    SenderID:            0x0000000000000000
    BuiltIn:             0
    ```
    
    This works (real event):
    
    ```
    [1mSenderID:            0x0ACEFADE00000004 NON KERNEL SENDER
    [0mBuiltIn:             0
    AttributeDataLength: 48
    AttributeData:       01 00 00 00 20 00 00 00 0a 0f 0a 0d 6b 65 79 62 6f 61 72 64 46 6f 63 75 73 12 02 10 01 1a 05 08 c1 b1 f8 69 20 02 28 00 00 00 00 00 00 00 00 00
    ```
    
- It seems that we have to do something with the event to make it be handled properly in `_physicalKeyboardEventForHIDEvent`
- Searching code in github: <https://github.com/search?o=desc&q=IOHIDEventCreateKeyboardEvent&s=indexed&type=Code>
- Found this:

```
- (BOOL)_sendHIDEvent:(IOHIDEventRef)eventRef
{
    if (!_ioSystemClient)
        _ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);

    if (eventRef) {
        RetainPtr<IOHIDEventRef> strongEvent = eventRef;
        dispatch_async(dispatch_get_main_queue(), ^{
            uint32_t contextID = [UIApplication sharedApplication].keyWindow._contextId;
            ASSERT(contextID);
            BKSHIDEventSetDigitizerInfo(strongEvent.get(), contextID, false, false, NULL, 0, 0);
            [[UIApplication sharedApplication] _enqueueHIDEvent:strongEvent.get()];
        });
    }
    return YES;
}
```

- Transferred this code to the project. Calling `BKSHIDEventSetDigitizerInfo` alone fixed the problem. Other code was added just to fix problems cause by adding that call.

Moral of the story: maybe I should try to search the solution first. However, the previous solution was also found on github and it didn't work on iOS 13 and without reverse engineering I couldn't tell why. But you should always keep in mind that someone probably already solved your issue.