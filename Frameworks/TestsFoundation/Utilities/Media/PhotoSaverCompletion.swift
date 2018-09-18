import MixboxFoundation

final class PhotoSaverCompletion: NSObject {
    private let completion: (DataResult<(), String>) -> ()
    
    init(completion: @escaping (DataResult<(), String>) -> ()) {
        self.completion = completion
    }
    
    var target: AnyObject? {
        return self
    }
    
    var action: Selector {
        return #selector(PhotoSaverCompletion.image(_:didFinishSavingWithError:contextInfo:))
    }
    
    @objc(image:didFinishSavingWithError:contextInfo:)
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion(.error(error.localizedDescription))
        } else {
            completion(.data(()))
        }
    }
}
