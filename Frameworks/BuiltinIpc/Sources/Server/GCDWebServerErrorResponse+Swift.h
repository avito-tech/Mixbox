#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <GCDWebServer/GCDWebServerErrorResponse.h>

@interface GCDWebServerErrorResponse (Swift)

- (nullable instancetype)initWithClientError:(GCDWebServerClientErrorHTTPStatusCode)code text:(nonnull NSString *)text;
- (nullable instancetype)initWithServerError:(GCDWebServerServerErrorHTTPStatusCode)code text:(nonnull NSString *)text;

@end

#endif
