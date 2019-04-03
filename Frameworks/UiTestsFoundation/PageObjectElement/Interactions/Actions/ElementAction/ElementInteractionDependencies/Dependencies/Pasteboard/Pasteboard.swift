// TODO: There is a possibility to make an implementation of Pasteboard that allows layers of buffers.
// For example, it setText action we use Pasteboard for storing string that is pasted into a textfield.
// So this actions removes previous value from pasteboard. It can be undesirable.
public protocol Pasteboard: class {
    var string: String? { get set }
}
