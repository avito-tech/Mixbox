#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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
