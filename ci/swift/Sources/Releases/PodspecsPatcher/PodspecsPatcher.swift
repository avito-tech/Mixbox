public protocol PodspecsPatcher {
    func setMixboxPodspecsSource(
        _ source: String)
        throws
    
    func resetMixboxPodspecsSource() throws
}
