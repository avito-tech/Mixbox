public protocol ElementVisibilityChecker: class {
    func percentageOfVisibleArea(snapshot: ElementSnapshot) -> CGFloat
    func percentageOfVisibleArea(elementUniqueIdentifier: String) -> CGFloat
}
