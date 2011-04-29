// Copyright (c) 2011 Tim Isted
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TIUError.h"
#import "AvailabilityMacros.h"
#import <execinfo.h>

NSString * const kTIUErrorUnderlyingErrorKey = @"kTIUErrorUnderlyingErrorKey";
NSString * const kTIUErrorStackTraceKey = @"kTIUErrorStackTraceKey";

@implementation TIUError

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#pragma mark -
#pragma mark Inspection
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\nUser Info:%@", [super description], [self userInfo]];
}
#endif

#pragma mark -
#pragma mark Error Generation
+ (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription
{
    return [self errorWithCode:aCode domain:aDomain localizedDescription:aDescription underlyingError:nil userInfo:nil];
}

+ (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription underlyingError:(NSError *)anUnderlyingError
{
    return [self errorWithCode:aCode domain:aDomain localizedDescription:aDescription underlyingError:anUnderlyingError userInfo:nil];
}

+ (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription userInfo:(NSDictionary *)someUserInfo
{
    return [self errorWithCode:aCode domain:aDomain localizedDescription:aDescription underlyingError:nil userInfo:someUserInfo];
}

+ (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription underlyingError:(NSError *)anUnderlyingError userInfo:(NSDictionary *)someUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3 + [someUserInfo count]];
    
    if( someUserInfo ) {
        [userInfo addEntriesFromDictionary:someUserInfo];
    }
    
    if( aDescription ) {
        [userInfo setValue:aDescription forKey:NSLocalizedDescriptionKey];
    }
    
    if( anUnderlyingError ) {
        [userInfo setValue:anUnderlyingError forKey:kTIUErrorUnderlyingErrorKey];
    }
    
    // Generate stack trace
    void *buffer[100]; 
    int numberOfStackSymbols = backtrace(buffer, 100);
    
    char **stackTraceStrings = backtrace_symbols(buffer, numberOfStackSymbols);
    
    NSMutableArray *stackTraceArray = [NSMutableArray arrayWithCapacity:numberOfStackSymbols];
    
    for( int currentString = 0; currentString < numberOfStackSymbols; currentString++ ) {
        [stackTraceArray addObject:[NSString stringWithCString:stackTraceStrings[currentString] encoding:NSASCIIStringEncoding]];
    }
    
    [userInfo setValue:stackTraceArray forKey:kTIUErrorStackTraceKey];
    
    free(stackTraceStrings);
    
    return [self errorWithDomain:aDomain code:aCode userInfo:userInfo];    
}

@end
