public protocol CocoapodsSearch {
    func search(
        name: String)
        throws
        -> CocoapodsSearchResult
}
