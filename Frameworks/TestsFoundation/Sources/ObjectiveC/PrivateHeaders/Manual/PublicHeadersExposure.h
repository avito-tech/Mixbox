#ifndef PublicHeadersExposure_h
#define PublicHeadersExposure_h

// TODO: How to include this in a pod?
// #include <execinfo.h>

int backtrace(void**,int) __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
char** backtrace_symbols(void* const*,int) __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);

#endif /* PublicHeadersExposure_h */
