// TODO: There is a possibility to make an implementation of Pasteboard that allows layers of buffers.
// For example, it setText action we use Pasteboard for storing string that is pasted into a textfield.
// So this actions removes previous value from pasteboard. It can be undesirable.
// Note that it is not as easy as it seems. You have to wait until pasteboard value is used before reverting it.
public protocol Pasteboard: class {
    func setString(_ string: String?) throws
    func getString() throws -> String?
}
