protocol Mockable {}

protocol Math: Mockable {
    func sum(_ a: Int, b: Int) -> Int
}
