#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

/*
 
IOHIDEventSystemClient.h ... I/O Kit HID Event System Client

Copyright (c) 2010  KennyTM~ <kennytm@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of the KennyTM~ nor the names of its contributors may be
  used to endorse or promote products derived from this software without
  specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

// With reference to http://www.opensource.apple.com/source/IOHIDFamily/IOHIDFamily-258.1/IOHIDLib/IOHIDEventServiceClass.h

#ifndef IOHID_EVENT_SYSTEM_CLIENT_H
#define IOHID_EVENT_SYSTEM_CLIENT_H

#include <CoreFoundation/CoreFoundation.h>
#include "IOHIDEventQueue.h"
#include "IOHIDEvent.h"

__BEGIN_DECLS

    typedef struct __IOHIDServiceClient * IOHIDServiceClientRef;
			
	typedef struct __IOHIDEventSystemClient
#if 0
	{
		void* x00;
		CFMachPortRef serverPort;	// 4
		CFRunLoopSourceRef serverSource;	// 8
		IOHIDEventSystemClientEventCallback callback;	// c
		void* target;	// 10
		void* refcon;	// 14
		CFMachPortRef queuePort;	// 18
		CFRunLoopSourceRef queueSource;	// 1c
		CFRunLoopSourceRef source2;	// 24
		CFRunLoopTimerRef timer;	// 28
		IOHIDEventQueueRef queue;	// 2c
		CFRunLoopRef runloop;	// 34
		CFStringRef mode;	// 38
	}
#endif
	* IOHIDEventSystemClientRef;
	
	typedef void(*IOHIDEventSystemClientEventCallback)(void* target, void* refcon, IOHIDEventQueueRef queue, IOHIDEventRef event);
	
	void IOHIDEventSystemClientRegisterEventCallback(IOHIDEventSystemClientRef client, IOHIDEventSystemClientEventCallback callback, void* target, void* refcon);
	void IOHIDEventSystemClientUnregisterEventCallback(IOHIDEventSystemClientRef client);
	
	void IOHIDEventSystemClientUnscheduleWithRunLoop(IOHIDEventSystemClientRef client, CFRunLoopRef runloop, CFStringRef mode);
	void IOHIDEventSystemClientScheduleWithRunLoop(IOHIDEventSystemClientRef client, CFRunLoopRef runloop, CFStringRef mode);
	
	CFPropertyListRef IOHIDEventSystemClientCopyProperty(IOHIDEventSystemClientRef client, CFStringRef property);
	Boolean IOHIDEventSystemClientSetProperty(IOHIDEventSystemClientRef client, CFStringRef property, CFPropertyListRef value);

    IOHIDEventSystemClientRef IOHIDEventSystemClient(void);
    IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef allocator);
    int IOHIDEventSystemClientSetMatching(IOHIDEventSystemClientRef client, CFDictionaryRef match);
    CFArrayRef IOHIDEventSystemClientCopyServices(IOHIDEventSystemClientRef);

    CFNumberRef IOHIDServiceClientCopyProperty(IOHIDServiceClientRef, CFStringRef);
    int IOHIDServiceClientSetProperty(IOHIDServiceClientRef, CFStringRef, CFNumberRef);
	
__END_DECLS

#endif



#endif
