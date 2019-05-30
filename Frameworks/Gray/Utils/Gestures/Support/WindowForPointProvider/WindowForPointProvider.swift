// TODO: Remove. Inject each event into an appropriate window and remove this class.
public protocol WindowForPointProvider: class {
    func window(point: CGPoint) -> UIWindow?
}
