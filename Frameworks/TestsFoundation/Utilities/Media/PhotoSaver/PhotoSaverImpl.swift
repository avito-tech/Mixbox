import MixboxFoundation

public final class PhotoSaverImpl: PhotoSaver {
    public init() {
    }
    
    public func save(
        image: UIImage,
        completion: @escaping (DataResult<(), ErrorString>) -> ())
    {
        let photoSaverCompletion = PhotoSaverCompletion(completion: completion)
        
        // Note: contextInfo parameter is not set, I don't know what it is
        UIImageWriteToSavedPhotosAlbum(image, photoSaverCompletion.target, photoSaverCompletion.action, nil)
    }
}
