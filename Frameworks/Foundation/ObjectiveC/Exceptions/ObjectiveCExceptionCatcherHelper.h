#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

NS_INLINE
void ObjectiveCExceptionCatcherHelper_try(NS_NOESCAPE void(^tryBlock)(),
                                          NS_NOESCAPE void(^catchBlock)(NSException *),
                                          NS_NOESCAPE void(^finallyBlock)())
{
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        catchBlock(exception);
    }
    @finally {
        finallyBlock();
    }
}

NS_ASSUME_NONNULL_END

#endif
