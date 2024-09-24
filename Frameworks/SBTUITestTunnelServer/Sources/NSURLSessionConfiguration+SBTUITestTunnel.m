#if defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) && defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER)
#error "SBTUITestTunnelServer is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER))
// The compilation is disabled
#else

// NSURLSessionConfiguration+SBTUITestTunnel.m
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

// https://github.com/AliSoftware/OHHTTPStubs/blob/master/OHHTTPStubs/Sources/NSURLSession/OHHTTPStubs%2BNSURLSessionConfiguration.m

#import "NSURLSessionConfiguration+SBTUITestTunnel.h"

#if SWIFT_PACKAGE
@import MixboxSBTUITestTunnelCommon;
#else
#import <MixboxSBTUITestTunnelCommon/SBTSwizzleHelpers.h>
#endif

#import "SBTProxyURLProtocol.h"


@implementation NSURLSessionConfiguration (SBTUITestTunnel)

+ (NSURLSessionConfiguration *)swz_defaultSessionConfiguration
{
    NSURLSessionConfiguration *config = [self swz_defaultSessionConfiguration];
    [self addSBTProxyProtocol:config];
    
    return config;
}

+ (NSURLSessionConfiguration *)swz_ephemeralSessionConfiguration
{
    NSURLSessionConfiguration *config = [self swz_ephemeralSessionConfiguration];
    [self addSBTProxyProtocol:config];
    
    return config;
}

+ (void)addSBTProxyProtocol:(NSURLSessionConfiguration *)sessionConfig
{
    NSMutableArray * urlProtocolClasses = [sessionConfig.protocolClasses mutableCopy];
    [urlProtocolClasses insertObject:[SBTProxyURLProtocol class] atIndex:0];
    sessionConfig.protocolClasses = urlProtocolClasses;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SBTTestTunnelClassSwizzle(self, @selector(defaultSessionConfiguration), @selector(swz_defaultSessionConfiguration));
        SBTTestTunnelClassSwizzle(self, @selector(ephemeralSessionConfiguration), @selector(swz_ephemeralSessionConfiguration));
    });
}

@end

#endif
