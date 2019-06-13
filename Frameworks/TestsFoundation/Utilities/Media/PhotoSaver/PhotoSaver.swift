import MixboxFoundation

public protocol PhotoSaver: class {
    func save(imagesProvider: ImagesProvider) throws
}
