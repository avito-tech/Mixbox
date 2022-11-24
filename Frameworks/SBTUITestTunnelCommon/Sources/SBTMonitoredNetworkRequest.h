#if defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_COMMON) && defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_COMMON)
#error "SBTUITestTunnelCommon is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_COMMON) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_COMMON))
// The compilation is disabled
#else

// SBTMonitoredNetworkRequest.h
//
// Copyright (C) 2016 Subito.it S.r.l (www.subito.it)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>

@class SBTRequestMatch;

@interface SBTMonitoredNetworkRequest : NSObject<NSCoding>

- (nullable NSString *)responseString;
- (nullable NSDictionary<NSString *, id> *)responseJSON;

- (nullable NSString *)requestString;
- (nullable NSDictionary<NSString *, id> *)requestJSON;

- (BOOL)matches:(nonnull SBTRequestMatch *)match;

@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) NSTimeInterval requestTime;

@property (nullable, nonatomic, strong) NSURLRequest *request;
@property (nullable, nonatomic, strong) NSURLRequest *originalRequest;
@property (nullable, nonatomic, strong) NSHTTPURLResponse *response;

@property (nullable, nonatomic, strong) NSData *responseData;

@property (nonatomic, assign) BOOL isStubbed;
@property (nonatomic, assign) BOOL isRewritten;

@end

#endif
