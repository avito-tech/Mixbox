import MixboxFoundation

final class PhotoSaver {
    func save(image: UIImage) -> DataResult<(), String> {
        var result: DataResult<(), String>?
        
        let photoSaverCompletion = PhotoSaverCompletion {
            result = $0
        }
        
        // Note: contextInfo parameter is not set, I don't know what it is
        UIImageWriteToSavedPhotosAlbum(image, photoSaverCompletion.target, photoSaverCompletion.action, nil)
        
        while true {
            if let result = result {
                return result
            }
            
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.05))
        }
    }
}
