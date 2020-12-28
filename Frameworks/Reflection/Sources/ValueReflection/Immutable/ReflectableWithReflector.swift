// This thing is kind of for violations of SRP.
// Implement this protocol in a model and a model can produce itself
// based on info that is provided by `Reflector`
//
// So in this case 2 responsibilities emerge: storage and filling the storage.
// It makes code less like raviolli, though.
//
protocol ReflectableWithReflector {
    static func reflect(reflector: Reflector) -> Self
}
