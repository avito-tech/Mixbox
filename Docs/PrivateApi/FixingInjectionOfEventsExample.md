# Fixing injection of events

This is a raw log that describes thought process, tools and techniques that were used:

- Discovered a bug when was updating project to support 13: `SetTestActionSetsTextProperlyTests` was failing.
- Wrote a test of injecting IOHID events (`KeyboardEventInjectorImplTests`).
- The cause of bug with text is somewhere inside `KeyboardEventInjectorImpl`.
- I set breakpoints in `-[UIApplication handleKeyHIDEvent:]`
- The function was called as expected.
- Started debugging a sample app (not in a test mode) running in a simulator.
- Pressed some keys on hardware keyboard. The same method was called `handleKeyHIDEvent:`.
- Opened `UIKitCore` in [Hopper (disassembler)](Disassembling.md) `/Applications/Xcode_11_1.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/UIKitCore.framework`
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
