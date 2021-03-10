public protocol GitTagAdder {
    func addTag(
        tagName: String,
        commitHash: String)
        throws
    
    func pushTag(
        tagName: String,
        remote: String)
        throws
}

extension GitTagAdder {
    public func addAndPushTag(
        tagName: String,
        commitHash: String,
        remote: String)
        throws
    {
        try addTag(tagName: tagName, commitHash: commitHash)
        try pushTag(tagName: tagName, remote: remote)
    }
}
