# Disassembling

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

## How to find where an Objective-C method is used

Example for `UITouch setView` selector in UIKitCore.framework.

- Search `UITouch setView` in Labels in the left panel, click result
- Switch to ASM mode (by default) in the middle panel ("mov add" button in navbar).
- Right-click `-[UITouch setView:]` (assuming you use left/right clicking in OSX)
- Left-click `References to -[UITouch setView:]`
- Left-click reference in a pop-up window

You will see this:

```
0000000001665e70 struct __objc_method {     ; "setView:","v24@0:8@16"
                     aSetview,              // name
                     aV240816_1356c6c,      // signature
                     -[UITouch setView:]    // implementation
                 }
```

- Right-click `aSetview`
- Left-click `References to "aSetview"`
- Search for `dq` (I have no idea what is it)
- Left-click something like `0x12345678           | dq    aSetview`

You will see:

```
000000000175f370         dq         aSetview  
```

- Right-click `aSetview`
- Left-click `References to address`
- A popup with all references will be opened. Click anything.

You will see:

```
/* @class UIView */
-(void)removeGestureRecognizer:(void *)arg2 {
    r14 = self;
    rax = [arg2 retain];
    r15 = rax;
    rax = [rax view];
    rax = [rax retain];
    [rax release];
    if (rax == r14) {
            [r15 setView:0x0];          // <------------------ HERE! -------------------
            [r14->_gestureRecognizers removeObject:r15];
            rax = [*_UIApp _gestureEnvironment];
            rax = [rax retain];
            [rax removeGestureRecognizer:r15];
            [rax release];
            rax = [r14 _window];
            rax = objc_unsafeClaimAutoreleasedReturnValue(rax);
            if (rax != 0x0) {
                    [[*_UIApp _touchesEventForWindow:rax] _invalidateGestureRecognizerForWindowCache];
            }
    }
    [r15 release];
    return;
}
```

Done. But not really. You can't find invocation of a method of a specific class. Only invocation of a specific selector.

In this example I searched for `touch` in a pop up hoping to see where setView is called on UITouch (maybe the caller has `touch` somewhere in its name).

```
/* @class UITouch */
+(void *)_createTouchesWithGSEvent:(struct __GSEvent *)arg2 phase:(long long)arg3 view:(void *)arg4 {
    r15 = [arg4 retain];
    r12 = [[UITouch alloc] init];
    var_40 = [[NSMutableSet alloc] initWithObjects:r12];
    [r12 setPhase:arg3];
    GSEventGetTimestamp(arg2);
    [r12 setTimestamp:arg3];
    [r12 setTapCount:0x1];
    rax = [r15 window];
    rax = [rax retain];
    [r12 setWindow:rax];
    [rax release];
    [r12 setView:r15];
    [r15 release];
    GSEventGetLocationInWindow(arg2);
    [r12 _setLocationInWindow:0x1 resetPrevious:0x0];
    [r12 _setIsFirstTouchForView:0x1];
    [r12 release];
    rax = var_40;
    return rax;
}
```

## Useful links to frameworks

UIKitCore: `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore`
UIKit.axbundle: `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/AccessibilityBundles/UIKit.axbundle/UIKit`

AXRuntime: `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/AXRuntime.framework/`

XCTest: `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework`
