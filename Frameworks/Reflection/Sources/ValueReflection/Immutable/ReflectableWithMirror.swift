protocol ReflectableWithMirror {
    static func reflect(mirror: Mirror) -> Self
}

extension ReflectableWithMirror {
    public static func reflect(reflected: Any) -> Self {
        return reflect(mirror: Mirror(reflecting: reflected))
    }
}
