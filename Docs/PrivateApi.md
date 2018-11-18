# How-To Private API

We used class-dump to generate headers for frameworks, we used disassembler to reveal behavior of proprietary code and also some signatures of C-functions (class-dump works only for Obj-C).

Pure class-dump is not enough to make good headers, we have a script `dump.py` that generates headers of XCTest and patches output of class-dump. It can be used when new Xcode is released and there are changes in APIs. Currently multiple XCode versions are supported.

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