public protocol DependencyInjection: DependencyResolver, DependencyRegisterer {
    // Call this method to complete container setup.
    // After this you can not add or remove definitions.
    // Trying to do so will cause runtime exception.
    func completeContainerSetup() throws
}
