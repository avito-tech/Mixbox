// Task that can be executed on current machine
public protocol LocalTask {
    var name: String { get }
    
    func execute() throws
}
