public protocol ElementVisibilityChecker {
    func percentageOfVisibleArea(snapshot: ElementSnapshot) -> CGFloat
    func percentageOfVisibleArea(elementUniqueIdentifier: String) -> CGFloat
}
