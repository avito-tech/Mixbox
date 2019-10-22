import MixboxFoundation
import MixboxUiKit

public final class PhotoSaverImpl: PhotoSaver {
    private let runLoopSpinnerLockFactory: RunLoopSpinnerLockFactory
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        runLoopSpinnerLockFactory: RunLoopSpinnerLockFactory,
        iosVersionProvider: IosVersionProvider)
    {
        self.runLoopSpinnerLockFactory = runLoopSpinnerLockFactory
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func save(imagesProvider: ImagesProvider) throws {
        let images = try imagesProvider.images()
        
        guard !images.isEmpty else {
            throw ErrorString("No photos to stub")
        }
        
        var errors = [Error]()
        
        onMainThread {
            saveConcurrently(
                images: images,
                onError: { error in
                    errors.append(error)
                }
            )
        }
        
        if !errors.isEmpty {
            throw ErrorString("Saving photos completed with errors: \(errors)")
        }
    }
    
    private func onMainThread(body: () -> ()) {
        if Thread.isMainThread {
            body()
        } else {
            DispatchQueue.main.sync {
                body()
            }
        }
    }
    
    private func saveConcurrently(
        images: [ImageProvider],
        onError: @escaping (Error) -> ())
    {
        do {
            let chunks = try chunkedImageProviders(images: images)
            
            chunks.forEach { images in
                saveChunk(
                    images: images,
                    onError: onError
                )
            }
        } catch {
            onError(error)
        }
    }
    
    private func chunkedImageProviders(
        images: [ImageProvider])
        throws
        -> [[ImageProvider]]
    {
        let chunks: [[ImageProvider]]
        
        // https://stackoverflow.com/questions/6097459/uiimagewritetosavedphotosalbum-saves-only-5-image-out-of-10-why
        // It is not ideal solution to parallelize the work... but it is better than not parallelizing.
        // Ideally we want to save maximum amount of images every moment of time.
        //
        // Visual example (maximum amout of images being saved = 3):
        //
        // +------------------+--------------------+
        // | How it works     | How it should work |
        // +--------+---------+--------+-----------+
        // | SAVING | WAITING | SAVING | WAITING   |
        // +--------+---------+--------+-----------+
        // | ooo    | oooo    | ooo    | oooo      |
        // | oo     | oooo    | ooo    | ooo       |
        // | o      | oooo    | ooo    | oo        |
        // | ooo    | o       | ooo    | o         |
        // | oo     | o       | ooo    |           |
        // | o      | o       | oo     |           |
        // | o      |         | o      |           |
        // +--------+---------+--------+-----------+
        //                      ^- more tasks are executed in parallel
        //
        // Note: limit is 5 on iOS 9, 10, 11. It seems that there is no limit on iOS 12 (I've tested with 10 images),
        // but i think it will be okay to have limit also on iOS 12. It will work. It will not require
        // writing stress tests (that will probably find issues).
        //
        // Note that icreasing limit increases performance. Here are raw durations of PhotoStubberTests (500 images were stubbed):
        //
        // Limit | Duration
        //     5 | 31.64s
        //    50 | 29.01s
        //    50 | 28.63s
        //    50 | 28.11s
        //     5 | 33.65s
        //     5 | 29.89s
        //     5 | 29.71s
        //    50 | 27.92s
        //    50 | 25.50s
        //       | Average
        //     5 | 31.22s
        //    50 | 27.83s
        //
        // Limit=50 saves 678ms per 100 images (vs Limit=5)
        //
        let ios12Limit = 50
        //
        // Got this error once: `iPhone 7, iOS 11.3: Failed to stub photos: Saving photos completed with errors: [Write busy, Write busy, Write busy]`
        // which means that only two photos were loaded. I'm afraid I don't know how it works, so I disabled paralellism.
        // Maybe it's better to have retries/fallbacks.
        let ios11OrLowerLimit = 1
        
        let maximumSimultaneousImageWriteToSavedPhotosAlbumOperationsAllowed = iosVersionProvider.iosVersion().majorVersion >= 12
            ? ios12Limit
            : ios11OrLowerLimit
        
        chunks = try images.mb_chunked(chunkSize: maximumSimultaneousImageWriteToSavedPhotosAlbumOperationsAllowed)
        
        return chunks
    }
    
    private func saveChunk(
        images: [ImageProvider],
        onError: @escaping (Error) -> ())
    {
        let runLoopSpinnerLock = runLoopSpinnerLockFactory.runLoopSpinnerLock(pollingInterval: 0.1)
        
        images.forEach { imageProvider in
            save(
                imageProvider: imageProvider,
                onError: onError,
                runLoopSpinnerLock: runLoopSpinnerLock
            )
        }
        
        runLoopSpinnerLock.wait()
    }
        
    private func save(
        imageProvider: ImageProvider,
        onError: @escaping (Error) -> (),
        runLoopSpinnerLock: RunLoopSpinnerLock)
    {
        do {
            let image = try imageProvider.image()
            
            runLoopSpinnerLock.enter()
            
            save(image: image) { result in
                result.onError { onError($0) }
                
                do {
                    try runLoopSpinnerLock.leave()
                } catch {
                    onError(error)
                }
            }
        } catch {
            onError(error)
        }
    }
    
    // Unfortunately UIImageWriteToSavedPhotosAlbum requires to:
    // 1. Call it on main thread (I am not sure it will cause problems, I just read it on the internet)
    // 2. Wait spinning run loop on main thread (e.g. if you use DispatchGroup it may result in a deadlock).
    // 3. Do not save more than 5 images at a time on iOS 9, 10 and 11 (works fine for 10 images on iOS 12.1).
    private func save(
        image: UIImage,
        completion: @escaping (DataResult<(), ErrorString>) -> ())
    {
        let photoSaverCompletion = PhotoSaverCompletion(completion: completion)
        
        // Note: contextInfo parameter is not set, I don't know what it is
        UIImageWriteToSavedPhotosAlbum(image, photoSaverCompletion.target, photoSaverCompletion.action, nil)
    }
}
