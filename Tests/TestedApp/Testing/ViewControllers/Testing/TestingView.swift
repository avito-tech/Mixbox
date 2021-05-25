import MixboxReflection

public protocol TestingView:
    ViewControllerContainerTypeProvider,
    InitializableWithTestingViewControllerSettings,
    ViewWithUtilities
{
}

extension TestingView {
    public static var viewControllerContainerType: ViewControllerContainerType {
        return .none
    }
}
