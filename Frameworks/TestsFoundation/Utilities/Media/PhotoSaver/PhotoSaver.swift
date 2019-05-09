import MixboxFoundation

public protocol PhotoSaver {
    func save(
        image: UIImage,
        completion: @escaping (DataResult<(), ErrorString>) -> ())
}
