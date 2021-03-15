public protocol GitTagDeleter {
    func deleteLocalTag(
        tagName: String)
        throws

    func deleteRemoteTag(
        tagName: String,
        remoteName: String)
        throws
}

extension GitTagDeleter {
    public func deleteLocalAndRemoteTag(
        tagName: String,
        remoteName: String)
        throws
    {
        try deleteLocalTag(
            tagName: tagName
        )
        try deleteRemoteTag(
            tagName: tagName,
            remoteName: remoteName
        )
    }
    
    // If you don't ignore errors and try to delete tag that doesn't exist,
    // git will return error. Code now is silly, it will not handle
    // specific case with non-existing tags, it will ignore every error.
    public func deleteLocalAndRemoteTagIgnoringAllErrors(
        tagName: String,
        remoteName: String)
        throws
    {
        try? deleteLocalTag(
            tagName: tagName
        )
        try? deleteRemoteTag(
            tagName: tagName,
            remoteName: remoteName
        )
    }
}
