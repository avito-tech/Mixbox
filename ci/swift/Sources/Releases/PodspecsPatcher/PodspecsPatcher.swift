public protocol PodspecsPatcher {
    func setMixboxFrameworkPodspecsVersion(
        _ version: Version)
        throws
    
    // Reverts everything
    func resetMixboxFrameworkPodspecsVersion()
        throws
}
