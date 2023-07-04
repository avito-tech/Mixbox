#if defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) && defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER)
#error "SBTUITestTunnelServer is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_S_B_T_U_I_TEST_TUNNEL_SERVER))
// The compilation is disabled
#else

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// SBTProxyURLProtocol.m
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

#import "SBTProxyURLProtocol.h"
#import "NSData+SHA1.h"
#import <MixboxSBTUITestTunnelCommon/SBTStubResponse.h>
#import <MixboxSBTUITestTunnelCommon/SBTRewrite.h>
#import <MixboxSBTUITestTunnelCommon/NSURLRequest+SBTUITestTunnelMatch.h>

static NSString * const SBTProxyURLOriginalRequestKey = @"SBTProxyURLOriginalRequestKey";
static NSString * const SBTProxyURLProtocolHandledKey = @"SBTProxyURLProtocolHandledKey";
static NSString * const SBTProxyURLProtocolMatchingRuleKey = @"SBTProxyURLProtocolMatchingRuleKey";
static NSString * const SBTProxyURLProtocolDelayResponseTimeKey = @"SBTProxyURLProtocolDelayResponseTimeKey";
static NSString * const SBTProxyURLProtocolStubResponse = @"SBTProxyURLProtocolStubResponse";
static NSString * const SBTProxyURLProtocolRewriteResponse = @"SBTProxyURLProtocolRewriteResponse";
static NSString * const SBTProxyURLProtocolBlockCookiesKey = @"SBTProxyURLProtocolBlockCookiesKey";
static NSString * const SBTProxyURLProtocolBlockKey = @"SBTProxyURLProtocolBlockKey";

typedef void(^SBTProxyResponseBlock)(NSURLRequest *request, NSURLRequest *originalRequest, NSHTTPURLResponse *response, NSData *responseData, NSTimeInterval requestTime, BOOL stubbed, BOOL rewritten);
typedef void(^SBTStubUpdateBlock)(NSURLRequest *request);

@interface SBTProxyURLProtocol() <NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *connection;
@property (nonatomic, strong) NSMutableDictionary<NSURLSessionTask *, NSMutableData *> *tasksData;
@property (nonatomic, strong) NSMutableDictionary<NSURLSessionTask *, NSDate *> *tasksTime;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *matchingRules;

@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation SBTProxyURLProtocol

+ (SBTProxyURLProtocol *)sharedInstance
{
    static dispatch_once_t once;
    static SBTProxyURLProtocol *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[SBTProxyURLProtocol alloc] init];
        [sharedInstance reset];
    });
    return sharedInstance;
}

+ (void)reset
{
    [self.sharedInstance reset];
}

- (void)reset
{
    self.matchingRules = [NSMutableArray array];
    self.tasksData = [NSMutableDictionary dictionary];
    self.tasksTime = [NSMutableDictionary dictionary];
}

# pragma mark - Proxying

+ (NSString *)proxyRequestsMatching:(SBTRequestMatch *)match delayResponse:(NSTimeInterval)delayResponseTime responseBlock:(void(^)(NSURLRequest *request, NSURLRequest *originalRequest, NSHTTPURLResponse *response, NSData *responseData, NSTimeInterval requestTime, BOOL isStubbed, BOOL isRewritten))block;
{
    NSDictionary *rule = @{SBTProxyURLProtocolMatchingRuleKey: match, SBTProxyURLProtocolDelayResponseTimeKey: @(delayResponseTime), SBTProxyURLProtocolBlockKey: block ? [block copy] : [NSNull null]};
    
    @synchronized (self.sharedInstance) {
        NSString *identifierToAdd = [self identifierForRule:rule];
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:identifierToAdd] && matchingRule[SBTProxyURLProtocolStubResponse] == nil) {
                NSLog(@"[UITestTunnelServer] Warning existing proxying request found, skipping");
                // return nil; remove this to handle throttle and monitor
            }
        }
        
        [self.sharedInstance.matchingRules addObject:rule];
    }
    
    return [self identifierForRule:rule];
}

+ (BOOL)proxyRequestsRemoveWithId:(nonnull NSString *)reqId
{
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:reqId] && matchingRule[SBTProxyURLProtocolStubResponse] == nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
    }
    
    return itemsToDelete.count > 0;
}

+ (void)proxyRequestsRemoveAll
{
    @synchronized (self.sharedInstance) {
        NSMutableArray<NSDictionary *> *itemsToDelete = [NSMutableArray array];
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if (matchingRule[SBTProxyURLProtocolStubResponse] == nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
        NSLog(@"%ld matching rules left", (long)self.sharedInstance.matchingRules.count);
    }
}

#pragma mark - Stubbing

+ (NSString *)stubRequestsMatching:(SBTRequestMatch *)match stubResponse:(SBTStubResponse *)stubResponse didStubRequest:(void(^)(NSURLRequest *request))block;
{
    NSDictionary *rule = @{SBTProxyURLProtocolMatchingRuleKey: match, SBTProxyURLProtocolStubResponse: stubResponse, SBTProxyURLProtocolBlockKey: block ? [block copy] : [NSNull null]};
    NSString *identifierToAdd = [self identifierForRule:rule];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:identifierToAdd] && matchingRule[SBTProxyURLProtocolStubResponse] != nil) {
                NSLog(@"[UITestTunnelServer] Warning existing stub request found, skipping.\n%@", matchingRule);
                return nil;
            }
        }
        
        [self.sharedInstance.matchingRules addObject:rule];
    }
    
    return identifierToAdd;
}

+ (BOOL)stubRequestsRemoveWithId:(nonnull NSString *)reqId
{
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:reqId] && matchingRule[SBTProxyURLProtocolStubResponse] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
    }
    
    return itemsToDelete.count > 0;
}

+ (void)stubRequestsRemoveAll
{
    @synchronized (self.sharedInstance) {
        NSMutableArray<NSDictionary *> *itemsToDelete = [NSMutableArray array];
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if (matchingRule[SBTProxyURLProtocolStubResponse] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
        NSLog(@"%ld matching rules left", (long)self.sharedInstance.matchingRules.count);
    }
}

#pragma mark - Rewrite

+ (NSString *)rewriteRequestsMatching:(SBTRequestMatch *)match rewrite:(SBTRewrite *)rewrite didRewriteRequest:(void(^)(NSURLRequest *request))block;
{
    NSDictionary *rule = @{SBTProxyURLProtocolMatchingRuleKey: match, SBTProxyURLProtocolRewriteResponse: rewrite, SBTProxyURLProtocolBlockKey: block ? [block copy] : [NSNull null]};
    NSString *identifierToAdd = [self identifierForRule:rule];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:identifierToAdd] && matchingRule[SBTProxyURLProtocolRewriteResponse] != nil) {
                NSLog(@"[UITestTunnelServer] Warning existing rewrite request found, skipping.\n%@", matchingRule);
                return nil;
            }
        }
        
        [self.sharedInstance.matchingRules addObject:rule];
    }
    
    return identifierToAdd;
}

+ (BOOL)rewriteRequestsRemoveWithId:(nonnull NSString *)reqId
{
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:reqId] && matchingRule[SBTProxyURLProtocolRewriteResponse] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
    }
    
    return itemsToDelete.count > 0;
}

+ (void)rewriteRequestsRemoveAll
{
    @synchronized (self.sharedInstance) {
        NSMutableArray<NSDictionary *> *itemsToDelete = [NSMutableArray array];
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if (matchingRule[SBTProxyURLProtocolRewriteResponse] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
        NSLog(@"%ld matching rules left", (long)self.sharedInstance.matchingRules.count);
    }
}

#pragma mark - Cookie Block Requests

+ (nullable NSString *)cookieBlockRequestsMatching:(nonnull SBTRequestMatch *)match didBlockCookieInRequest:(void(^)(NSURLRequest *request))block;
{
    NSDictionary *rule = @{SBTProxyURLProtocolMatchingRuleKey: match, SBTProxyURLProtocolBlockCookiesKey: @(YES), SBTProxyURLProtocolBlockKey: block ? [block copy] : [NSNull null]};
    NSString *identifierToAdd = [self identifierForRule:rule];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:identifierToAdd] && matchingRule[SBTProxyURLProtocolBlockCookiesKey] != nil) {
                NSLog(@"[UITestTunnelServer] Warning existing cookie request found, skipping.\n%@", matchingRule);
                return nil;
            }
        }
        
        [self.sharedInstance.matchingRules addObject:rule];
    }
    
    return identifierToAdd;
}

+ (BOOL)cookieBlockRequestsRemoveWithId:(nonnull NSString *)reqId
{
    NSMutableArray *itemsToDelete = [NSMutableArray array];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([[self identifierForRule:matchingRule] isEqualToString:reqId] && matchingRule[SBTProxyURLProtocolBlockCookiesKey] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
    }
    
    return itemsToDelete.count > 0;
}

+ (void)cookieBlockRequestsRemoveAll
{
    @synchronized (self.sharedInstance) {
        NSMutableArray<NSDictionary *> *itemsToDelete = [NSMutableArray array];
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if (matchingRule[SBTProxyURLProtocolBlockCookiesKey] != nil) {
                [itemsToDelete addObject:matchingRule];
            }
        }
        
        [self.sharedInstance.matchingRules removeObjectsInArray:itemsToDelete];
        NSLog(@"%ld matching rules left", (long)self.sharedInstance.matchingRules.count);
    }
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:SBTProxyURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return ([self matchingRulesForRequest:request] != nil);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSArray<NSDictionary *> *matchingRules = [SBTProxyURLProtocol matchingRulesForRequest:self.request];
    NSDictionary *stubRule = nil;
    NSDictionary *proxyRule = nil;
    NSDictionary *cookieBlockRule = nil;
    NSDictionary *rewriteRule = nil;
    for (NSDictionary *matchingRule in matchingRules) {
        if (matchingRule[SBTProxyURLProtocolStubResponse]) {
            if (stubRule != nil) {
                NSLog(@"Multiple stubs registered for request %@!", self.request);
                for (NSDictionary *dMatchingRule in matchingRules) {
                    NSLog(@"-> %@", dMatchingRule);
                }
            }
            
            stubRule = matchingRule;
        } else if (matchingRule[SBTProxyURLProtocolRewriteResponse]) {
            rewriteRule = matchingRule;
        } else if (matchingRule[SBTProxyURLProtocolBlockCookiesKey]) {
            cookieBlockRule = matchingRule;
        } else {
            // we can have multiple matching rule here. For example if we throttle and monitor at the same time
            proxyRule = matchingRule;
        }
    }
    
    if (stubRule) {
        // STUB REQUEST
        SBTStubUpdateBlock didStubRequestBlock = stubRule[SBTProxyURLProtocolBlockKey];
        
        SBTStubResponse *stubResponse = stubRule[SBTProxyURLProtocolStubResponse];
        NSInteger stubbingStatusCode = stubResponse.returnCode;
        
        NSTimeInterval stubbingResponseTime = stubResponse.responseTime;
        if (stubbingResponseTime == 0.0 && proxyRule) {
            // if response time is not set in stub but set in proxy
            stubbingResponseTime = [proxyRule[SBTProxyURLProtocolDelayResponseTimeKey] doubleValue];
        }
        
        if (stubbingResponseTime < 0) {
            // When negative delayResponseTime is the faked response time expressed in KB/s
            stubbingResponseTime = stubResponse.data.length / (1024 * ABS(stubbingResponseTime));
        }
        
        __weak typeof(self)weakSelf = self;
        id<NSURLProtocolClient>client = self.client;
        NSURLRequest *request = self.request;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(stubbingResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            if (stubResponse.failureCode != 0) {
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:stubResponse.failureCode userInfo:nil];
                
                [client URLProtocol:strongSelf didFailWithError:error];
                [client URLProtocolDidFinishLoading:strongSelf];
            } else {
                strongSelf.response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:stubbingStatusCode HTTPVersion:nil headerFields:stubResponse.headers];
                
                [client URLProtocol:strongSelf didReceiveResponse:strongSelf.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                [client URLProtocol:strongSelf didLoadData:stubResponse.data];
                [client URLProtocolDidFinishLoading:strongSelf];
            }
            
            // check if the request is also proxied, we might need to manually invoke the block here
            if (proxyRule) {
                for (NSDictionary *matchingRule in matchingRules) {
                    if (!matchingRule[SBTProxyURLProtocolStubResponse]) {
                        SBTProxyResponseBlock block = matchingRule[SBTProxyURLProtocolBlockKey];
                        
                        if (![block isEqual:[NSNull null]] && block != nil) {
                            __unused SBTRequestMatch *requestMatch = proxyRule[SBTProxyURLProtocolMatchingRuleKey];
                            NSLog(@"[UITestTunnelServer] Throttling or monitoring stubbed %@ request: %@\n\nMatching rule:\n%@", [self.request HTTPMethod], [self.request URL], requestMatch);
                            
                            block(request, request, (NSHTTPURLResponse *)strongSelf.response, stubResponse.data, stubbingResponseTime, YES, NO); // stubbed requests are not rewritten
                        }
                    }
                }
            }
            
            if (![didStubRequestBlock isEqual:[NSNull null]] && didStubRequestBlock != nil) {
                __unused SBTRequestMatch *requestMatch = stubRule[SBTProxyURLProtocolMatchingRuleKey];
                NSLog(@"[UITestTunnelServer] Stubbing %@ request: %@\n\nMatching rule:\n%@\n\nResponse:\n%@", [self.request HTTPMethod], [self.request URL], requestMatch, stubResponse);
                
                didStubRequestBlock(request);
            }
        });
        
        return;
    }
    
    if (proxyRule != nil || rewriteRule != nil || cookieBlockRule != nil) {
        __unused SBTRequestMatch *requestMatch1 = proxyRule[SBTProxyURLProtocolMatchingRuleKey];
        __unused SBTRequestMatch *requestMatch2 = cookieBlockRule[SBTProxyURLProtocolMatchingRuleKey];
        __unused SBTRequestMatch *requestMatch3 = rewriteRule[SBTProxyURLProtocolMatchingRuleKey];
        NSLog(@"[UITestTunnelServer] Throttling or monitoring %@ request: %@\n\nMatching rule:\n%@", [self.request HTTPMethod], [self.request URL], requestMatch1 ?: requestMatch2 ?: requestMatch3);
        
        NSMutableURLRequest *newRequest = [self.request mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:SBTProxyURLProtocolHandledKey inRequest:newRequest];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        
        if (cookieBlockRule != nil) {
            [newRequest addValue:@"" forHTTPHeaderField:@"Cookie"];
        } else {
            [self moveCookiesToHeader:newRequest];
        }
        
        SBTRewrite *rewrite = [self rewriteRuleForCurrentRequest];
        if (rewrite != nil) {
            newRequest.URL = [rewrite rewriteUrl:newRequest.URL];
            newRequest.allHTTPHeaderFields = [rewrite rewriteRequestHeaders:newRequest.allHTTPHeaderFields];
            newRequest.HTTPBody = [rewrite rewriteRequestBody:newRequest.HTTPBody];
        }
        
        self.connection = [session dataTaskWithRequest:newRequest];
        
        [SBTProxyURLProtocol sharedInstance].tasksTime[self.connection] = [NSDate date];
        [SBTProxyURLProtocol sharedInstance].tasksData[self.connection] = [NSMutableData data];
        
        [self.connection resume];
    }
}

- (void)stopLoading
{
    [self.connection cancel];
}

- (void)moveCookiesToHeader:(NSMutableURLRequest *)newRequest
{
    // Move cookies from storage to headers, useful to properly extract cookies when monitoring requests
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:newRequest.URL];
    
    if (cookies.count > 0) {
        // instead of calling [newRequest addValue:forHTTPHeaderField:] multiple times
        // https://stackoverflow.com/questions/16305814/are-multiple-cookie-headers-allowed-in-an-http-request
        NSMutableString *multipleCookieString = [NSMutableString string];
        for (NSHTTPCookie* cookie in cookies) {
            [multipleCookieString appendFormat:@"%@=%@;", cookie.name, cookie.value];
        }
        
        [newRequest setValue:multipleCookieString forHTTPHeaderField:@"Cookie"];
    }
}

#pragma mark - NSURLSession Delegates

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if ([self rewriteRuleForCurrentRequest] != nil) {
        // if we're rewriting the request we will send only a didLoadData callback after rewriting content once everything was received
    } else {
        [self.client URLProtocol:self didLoadData:data];
    }
    
    NSMutableData *taskData = [[SBTProxyURLProtocol sharedInstance].tasksData objectForKey:dataTask];
    NSAssert(taskData != nil, @"Should not be nil");
    [taskData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error) {
        NSArray<NSDictionary *> *matchingRules = [SBTProxyURLProtocol matchingRulesForRequest:self.request];
        
        NSData *responseData = [[SBTProxyURLProtocol sharedInstance].tasksData objectForKey:task];
        NSAssert(responseData != nil, @"Should not be nil");
        [[SBTProxyURLProtocol sharedInstance].tasksData removeObjectForKey:task];
        
        self.response = task.response;
        
        SBTRewrite *rewrite = [self rewriteRuleForCurrentRequest];
        BOOL isRequestRewritten = (rewrite != nil);
        if (isRequestRewritten) {
            responseData = [rewrite rewriteResponseBody:responseData];
            NSHTTPURLResponse *taskResponse = (NSHTTPURLResponse *)task.response;
            if ([taskResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                NSDictionary *headers = [rewrite rewriteResponseHeaders:taskResponse.allHeaderFields];
                NSInteger statusCode = [rewrite rewriteStatusCode:taskResponse.statusCode];
                self.response = [[NSHTTPURLResponse alloc] initWithURL:taskResponse.URL statusCode:statusCode HTTPVersion:nil headerFields:headers];
            }
        }
        
        NSURLRequest *request = self.request;
        NSURLResponse *response = self.response;

        NSTimeInterval requestTime = -1.0 * [[SBTProxyURLProtocol sharedInstance].tasksTime[task] timeIntervalSinceNow];
        NSTimeInterval delayResponseTime = [self delayResponseTime];
        NSTimeInterval blockDispatchTime = MAX(0.0, delayResponseTime - requestTime);
        
        __weak typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(blockDispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            if (isRequestRewritten) {
                [weakSelf.client URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                [weakSelf.client URLProtocol:weakSelf didLoadData:responseData];
            }
            [weakSelf.client URLProtocolDidFinishLoading:strongSelf];
        });
        
        for (NSDictionary *matchingRule in matchingRules) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(blockDispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SBTProxyResponseBlock block = matchingRule[SBTProxyURLProtocolBlockKey];
                
                if (![block isEqual:[NSNull null]] && block != nil) {
                    NSURLRequest *originalRequest = [NSURLProtocol propertyForKey:SBTProxyURLOriginalRequestKey inRequest:request];
                    block(request ?: task.currentRequest, originalRequest ?: task.originalRequest, (NSHTTPURLResponse *)response, responseData, requestTime, NO, isRequestRewritten);
                }
            });
        }
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    NSMutableURLRequest *mRequest = [request mutableCopy];
    
    [NSURLProtocol removePropertyForKey:SBTProxyURLProtocolHandledKey inRequest:mRequest];
    if (![NSURLProtocol propertyForKey:SBTProxyURLOriginalRequestKey inRequest:mRequest]) {
        // don't handle double (or more) redirects
        [NSURLProtocol setProperty:self.request forKey:SBTProxyURLOriginalRequestKey inRequest:mRequest];
    }
    
    [self.client URLProtocol:self wasRedirectedToRequest:mRequest redirectResponse:response];
    
    completionHandler(mRequest);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    if ([self rewriteRuleForCurrentRequest] != nil) {
        // if we're rewriting the request we will send only a didReceiveResponse callback after rewriting content once everything was received
    } else {
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }
    
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - Helper Methods

- (NSTimeInterval)delayResponseTime
{
    NSTimeInterval retResponseTime = 0.0;
    NSArray<NSDictionary *> *matchingRules = [SBTProxyURLProtocol matchingRulesForRequest:self.request];
    
    for (NSDictionary *matchingRule in matchingRules) {
        NSTimeInterval delayResponseTime = [matchingRule[SBTProxyURLProtocolDelayResponseTimeKey] doubleValue];
        if (delayResponseTime < 0 && [self.response isKindOfClass:[NSHTTPURLResponse class]]) {
            // When negative delayResponseTime is the faked response time expressed in KB/s
            NSHTTPURLResponse *requestResponse = (NSHTTPURLResponse *)self.response;
            
            NSUInteger contentLength = [requestResponse.allHeaderFields[@"Content-Length"] unsignedIntValue];
            
            delayResponseTime = contentLength / (1024 * ABS(delayResponseTime));
        }
        
        retResponseTime = MAX(retResponseTime, delayResponseTime);
    }
    
    return retResponseTime;
}

+ (NSArray<NSDictionary *> *)matchingRulesForRequest:(NSURLRequest *)request
{
    NSMutableArray *ret = [NSMutableArray array];
    
    @synchronized (self.sharedInstance) {
        for (NSDictionary *matchingRule in self.sharedInstance.matchingRules) {
            if ([matchingRule.allKeys containsObject:SBTProxyURLProtocolMatchingRuleKey]) {
                NSURLRequest *originalRequest = [NSURLProtocol propertyForKey:SBTProxyURLOriginalRequestKey inRequest:request];
                
                if ([(originalRequest ?: request) matches:matchingRule[SBTProxyURLProtocolMatchingRuleKey]]) {
                    [ret addObject:matchingRule];
                }
            } else {
                NSAssert(NO, @"???");
            }
        }
    }
    
    return ret.count > 0 ? ret : nil;
}

+ (NSString *)identifierForRule:(NSDictionary *)rule
{
    NSString *identifier = nil;
    if ([rule.allKeys containsObject:SBTProxyURLProtocolMatchingRuleKey]) {
        NSData *ruleData = [NSKeyedArchiver archivedDataWithRootObject:rule[SBTProxyURLProtocolMatchingRuleKey]];
        
        identifier = [ruleData SHA1];
    } else {
        NSAssert(NO, @"???");
    }
    
    NSString *prefix = nil;
    if (rule[SBTProxyURLProtocolStubResponse]) {
        prefix = @"stb-";
    } else if (rule[SBTProxyURLProtocolDelayResponseTimeKey]) {
        prefix = @"thr-";
    } else if (rule[SBTProxyURLProtocolRewriteResponse]) {
        prefix = @"rwr-";
    } else if (rule[SBTProxyURLProtocolBlockKey] && ![rule[SBTProxyURLProtocolBlockKey] isKindOfClass:[NSNull class]]) {
        prefix = @"mon-";
    }
    
    NSAssert(prefix, @"Prefix can't be nil!");
    
    return [prefix stringByAppendingString:identifier];
}

- (SBTRewrite *)rewriteRuleForCurrentRequest
{
    NSArray<NSDictionary *> *matchingRules = [SBTProxyURLProtocol matchingRulesForRequest:self.request];
    for (NSDictionary *matchingRule in matchingRules) {
        if (matchingRule[SBTProxyURLProtocolRewriteResponse] != nil) {
            return matchingRule[SBTProxyURLProtocolRewriteResponse];
        }
    }
    
    return nil;
}

@end

#pragma clang diagnostic pop

#endif
