# Runtime

## Useful lldb shortcuts

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

## Swizzling

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
