#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTMessagingRole_SiriAutomation
- (void)_XCT_injectVoiceRecognitionAudioInputPaths:(NSArray *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)_XCT_injectAssistantRecognitionStrings:(NSArray *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)_XCT_startSiriUIRequestWithAudioFileURL:(NSURL *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)_XCT_startSiriUIRequestWithText:(NSString *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)_XCT_requestSiriEnabledStatus:(void (^)(_Bool, NSError *))arg1;
@end

#endif
