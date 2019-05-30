import MixboxFoundation

public protocol PhotoSaver: class {
    func save(
        image: UIImage,
        completion: @escaping (DataResult<(), ErrorString>) -> ())
}
