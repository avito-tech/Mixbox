#import "ObjectiveCExceptionCatcherHelper.h"

#import <Foundation/Foundation.h>

@interface EmptyClass_bf54cf38879b430fb36aa6fde6604e34 : NSObject
@end

@implementation EmptyClass_bf54cf38879b430fb36aa6fde6604e34 {}
@end



//#ifdef MIXBOX_ENABLE_IN_APP_SERVICES
//
//#warning "Defined MIXBOX_ENABLE_IN_APP_SERVICES"
//
////#if defined(MIXBOX_ENABLE_FRAMEWORK_FOUNDATION) && defined(MIXBOX_DISABLE_FRAMEWORK_FOUNDATION)
////#error "Foundation is marked as both enabled and disabled, choose one of the flags"
////#elif defined(MIXBOX_DISABLE_FRAMEWORK_FOUNDATION) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_FOUNDATION))
////// The compilation is disabled
////#else
//
//@import Foundation;
//
//NS_ASSUME_NONNULL_BEGIN
//
//NS_INLINE
//void ObjectiveCExceptionCatcherHelper_try(NS_NOESCAPE void(^tryBlock)(),
//                                          NS_NOESCAPE void(^catchBlock)(NSException *),
//                                          NS_NOESCAPE void(^finallyBlock)())
//{
//    @try {
//        tryBlock();
//    }
//    @catch (NSException *exception) {
//        catchBlock(exception);
//    }
//    @finally {
//        finallyBlock();
//    }
//}
//
//NS_ASSUME_NONNULL_END
//
//#endif
