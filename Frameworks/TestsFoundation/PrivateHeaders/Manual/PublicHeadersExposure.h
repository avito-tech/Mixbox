#ifndef PublicHeadersExposure_h
#define PublicHeadersExposure_h

// TODO: How to include this in a pod?
// #include <execinfo.h>

int backtrace(void**,int);
char** backtrace_symbols(void* const*,int);

#endif /* PublicHeadersExposure_h */
