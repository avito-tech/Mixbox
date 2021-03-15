public protocol PodspecsPatcher {
    func setMixboxFrameworkPodspecsVersion(
        _ version: Version)
        throws
}
