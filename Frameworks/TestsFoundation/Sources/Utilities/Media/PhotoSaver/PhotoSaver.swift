import MixboxFoundation

public protocol PhotoSaver: AnyObject {
    func save(imagesProvider: ImagesProvider) throws
}
