#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class KeyboardTree: PrivateClassWrapper<UIKBTree, NSObject> {
    public var keys: [KeyboardTree] {
        get throws {
            try underlyingPrivateApiObject.keys().map { array in
                try array.map { object in
                    return try KeyboardTree(
                        any: object
                    )
                }
            }.unwrapOrThrow()
        }
    }
    
    public var name: String {
        get throws {
            try underlyingPrivateApiObject.name().unwrapOrThrow()
        }
    }
    
    public var displayString: String? {
        underlyingPrivateApiObject.displayString()
    }
    
    public var representedString: String? {
        underlyingPrivateApiObject.representedString()
    }
    
    public var localizationKey: String? {
        underlyingPrivateApiObject.localizationKey()
    }
    
    public var displayRowHint: Int {
        underlyingPrivateApiObject.displayRowHint()
    }
    
    public var shape: KeyboardShape {
        get throws {
            let shape = try underlyingPrivateApiObject.shape().unwrapOrThrow()
            
            return KeyboardShape(
                underlyingPrivateApiObject: shape,
                underlyingPublicApiObject: shape
            )
        }
    }
}

#endif
