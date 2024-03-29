#if defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) && defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER)
#error "SBTUITestTunnelServer is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER))
// The compilation is disabled
#else

// SBTProxyURLProtocol.h
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
#import <MixboxSBTUITestTunnelCommon/SBTRequestMatch.h>

@class SBTStubResponse;
@class SBTRewrite;

@interface SBTProxyURLProtocol : NSURLProtocol

+ (void)reset;

#pragma mark - Proxy Requests

+ (nullable NSString *)proxyRequestsMatching:(nonnull SBTRequestMatch *)match delayResponse:(NSTimeInterval)delayResponseTime responseBlock:(nullable void(^)(NSURLRequest * __nullable, NSURLRequest * __nullable, NSHTTPURLResponse * __nullable , NSData * __nullable, NSTimeInterval, BOOL, BOOL))block;
+ (BOOL)proxyRequestsRemoveWithId:(nonnull NSString *)reqId;
+ (void)proxyRequestsRemoveAll;

#pragma mark - Stubbing Requests

+ (nullable NSString *)stubRequestsMatching:(nonnull SBTRequestMatch *)match stubResponse:(nonnull SBTStubResponse *)stubResponse didStubRequest:(nullable void(^)(NSURLRequest * __nullable))block;
+ (BOOL)stubRequestsRemoveWithId:(nonnull NSString *)reqId;
+ (void)stubRequestsRemoveAll;

#pragma mark - Rewrite Requests

+ (nullable NSString *)rewriteRequestsMatching:(nonnull SBTRequestMatch *)match rewrite:(nonnull SBTRewrite *)rewrite didRewriteRequest:(nullable void(^)(NSURLRequest * __nullable))block;
+ (BOOL)rewriteRequestsRemoveWithId:(nonnull NSString *)reqId;
+ (void)rewriteRequestsRemoveAll;

#pragma mark - Cookie Block Requests

+ (nullable NSString *)cookieBlockRequestsMatching:(nonnull SBTRequestMatch *)match didBlockCookieInRequest:(nullable void(^)(NSURLRequest * __nullable))block;
+ (BOOL)cookieBlockRequestsRemoveWithId:(nonnull NSString *)reqId;
+ (void)cookieBlockRequestsRemoveAll;

@end

#endif
