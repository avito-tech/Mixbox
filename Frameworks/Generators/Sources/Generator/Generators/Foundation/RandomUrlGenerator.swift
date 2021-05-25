#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation

public final class RandomUrlGenerator: Generator<URL> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            let stringGenerator: RandomStringGenerator = RandomStringGenerator(
                randomNumberProvider: randomNumberProvider,
                lengthGenerator: ConstantGenerator(20)
            )
            
            let randomString = try stringGenerator.generate()
            
            guard let url = URL(string: randomString) else {
                throw GeneratorError("Could not initialize url with random string \(randomString)")
            }
            
            return url
        }
    }
}

#endif
