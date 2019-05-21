public final class DelegatingSimctl:
    Simctl,
    SimctlListHolder,
    SimctlBootHolder,
    SimctlShutdownHolder,
    SimctlCreateHolder
{
    public let simctlList: SimctlList
    public let simctlBoot: SimctlBoot
    public let simctlShutdown: SimctlShutdown
    public let simctlCreate: SimctlCreate
    
    public init(
        simctlList: SimctlList,
        simctlBoot: SimctlBoot,
        simctlShutdown: SimctlShutdown,
        simctlCreate: SimctlCreate)
    {
        self.simctlList = simctlList
        self.simctlBoot = simctlBoot
        self.simctlShutdown = simctlShutdown
        self.simctlCreate = simctlCreate
    }
}
