#if MIXBOX_ENABLE_IN_APP_SERVICES

// TODO: Split everywhere, remove this protocol:
public protocol FakeCellManager:
    FakeCellManagerForCollectionView,
    FakeCellManagerForCollectionViewCell
{
}

#endif
