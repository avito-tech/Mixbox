public protocol TestingView: ViewControllerContainerTypeProvider, InitializableWithTestingViewControllerSettings {
}

extension TestingView {
    public static var viewControllerContainerType: ViewControllerContainerType {
        return .none
    }
}
