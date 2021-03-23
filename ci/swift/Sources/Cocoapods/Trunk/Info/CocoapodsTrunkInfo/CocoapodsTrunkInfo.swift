public protocol CocoapodsTrunkInfo {
    func info(
        podName: String)
        throws
        -> CocoapodsTrunkInfoResult
}
