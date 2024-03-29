#if defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) && defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER)
#error "SBTUITestTunnelServer is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER))
// The compilation is disabled
#else

// SBTUITestTunnelServer.h
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

@interface SBTUITestTunnelServer : NSObject

/**
 *  Start the tunnel server
 */
+ (void)takeOff;

/**
 *  This method is used to workaround the 'UI Testing Failure - Failure getting refresh snapshot Error Domain=XCTestManagerErrorDomain Code=9 "Error getting main window -25204"' error
 *
 *  Usage: after takeOff immediately call takeOffCompleted:NO, then once you're sure the initial viewcontroller is up and running, call takeOffCompleted:YES
 */
+ (void)takeOffCompleted:(BOOL)completed;

/**
 *  Register a custom command. It is your responsibility to unregister the custom command when it is no longer needed
 *
 *  @param commandName that will match [SBTUITunneledApplication performCustomCommandNamed:object:]
 *  @param block the block of code that will be executed once the command is received
 */
+ (void)registerCustomCommandNamed:(nonnull NSString *)commandName block:(nonnull NSObject *_Nullable(^)(NSObject * _Nullable object))block;

/**
 *  Unregister a custom command.
 *
 *  @param commandName the name of the custom command that was registered using [SBTUITestTunnelServer registerCustomCommandNamed:block:]
 */
+ (void)unregisterCommandNamed:(nonnull NSString *)commandName;

/**
 *  Internal, don't use.
 */
+ (nonnull NSString *)performCommand:(nonnull NSString *)commandName params:(nonnull NSDictionary<NSString *, NSString *> *)params;

@end

#endif
