#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface NSError (XCTAutomationSupportErrors)
+ (id)_xctas_error:(long long)arg1 userInfo:(id)arg2 description:(id)arg3 arguments:(struct __va_list_tag [1])arg4;
+ (id)_xctas_error:(long long)arg1 userInfo:(id)arg2 description:(id)arg3;
+ (id)_xctas_error:(long long)arg1 description:(id)arg2;
@property(readonly) _Bool xctas_isProcessStallError;
@property(readonly) _Bool xctas_isUnknownElementError;
@property(readonly) _Bool xctas_isNoMatchingElementError;
@end

#endif