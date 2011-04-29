#TIUError
*A utility subclass of NSError, adding helper class factory methods that include a stack trace in the user info, and overriding description to display the user info on a Mac*  

Tim Isted  
[http://www.timisted.net](http://www.timisted.net)  
Twitter: @[timisted](http://twitter.com/timisted)

##License
TIUError is offered under the **MIT** license.

##Summary
`TIUError` is a utility subclass of `NSError` to add a few class factory methods, each of which include a stack trace in the user info:

    + (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription;
    + (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription underlyingError:(NSError *)anUnderlyingError;
    + (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription userInfo:(NSDictionary *)someUserInfo;
    + (NSError *)errorWithCode:(NSInteger)aCode domain:(NSString *)aDomain localizedDescription:(NSString *)aDescription underlyingError:(NSError *)anUnderlyingError userInfo:(NSDictionary *)someUserInfo;

The subclass also overrides the `description` method, if compiling a Mac project, to display the full contents of the error's `userInfo` dictionary. This method is not overridden if compiling for iOS, as the default behavior is to display the full `userInfo` already.

If you provide your own user info, this will be merged with the generated user info, using keys described below.

Because of the way the stack trace is generated, it will obviously include the methods used to generate the error.

##Compatibility
`TIUError` _should_ be compatible with **any** version of Mac OS or iOS because the stack trace is generated using `backtrace()` and `backtrace_symbols()` functions, rather than the `[NSThread callStackSymbols]` method, which is only available on the desktop under Mac OS X 10.6+, or under iOS 4.0+.

##Example Usage for Mac OS X
Using the following code in a desktop application's app delegate:

    - (void)applicationDidFinishLaunching:(NSNotification *)aNotification
    {
        NSError *error = [TIUError errorWithCode:1 domain:@"com.timisted.errors" localizedDescription:@"Test error"];

        NSLog(@"%@", error);
    }

yields the following output in the console:

    Error Domain=com.timisted.errors Code=1 UserInfo=0x10043b110 "Test error"
    User Info:{
        NSLocalizedDescription = "Test error";
        kTIUErrorStackTraceKey =     (
            "0   ErrorTest                           0x00000001000013d7 +[TIUError errorWithCode:domain:localizedDescription:underlyingError:userInfo:] + 327",
            "1   ErrorTest                           0x00000001000011ba +[TIUError errorWithCode:domain:localizedDescription:] + 74",
            "2   ErrorTest                           0x0000000100001072 -[ErrorTestAppDelegate applicationDidFinishLaunching:] + 82",
            "3   Foundation                          0x00007fff800308ea _nsnote_callback + 167",
            "4   CoreFoundation                      0x00007fff82563000 __CFXNotificationPost + 1008",
            "5   CoreFoundation                      0x00007fff8254f578 _CFXNotificationPostNotification + 200",
            "6   Foundation                          0x00007fff8002784e -[NSNotificationCenter postNotificationName:object:userInfo:] + 101",
            "7   AppKit                              0x00007fff81a153d6 -[NSApplication _postDidFinishNotification] + 100",
            "8   AppKit                              0x00007fff81a1530b -[NSApplication _sendFinishLaunchingNotification] + 66",
            "9   AppKit                              0x00007fff81ae0305 -[NSApplication(NSAppleEventHandling) _handleAEOpen:] + 219",
            "10  AppKit                              0x00007fff81adff81 -[NSApplication(NSAppleEventHandling) _handleCoreEvent:withReplyEvent:] + 77",
            "11  Foundation                          0x00007fff8005ee42 -[NSAppleEventManager dispatchRawAppleEvent:withRawReply:handlerRefCon:] + 360",
            "12  Foundation                          0x00007fff8005ec72 _NSAppleEventManagerGenericHandler + 114",
            "13  AE                                  0x00007fff80805323 _Z20aeDispatchAppleEventPK6AEDescPS_jPh + 162",
            "14  AE                                  0x00007fff8080521c _ZL25dispatchEventAndSendReplyPK6AEDescPS_ + 32",
            "15  AE                                  0x00007fff80805123 aeProcessAppleEvent + 210",
            "16  HIToolbox                           0x00007fff88ddd619 AEProcessAppleEvent + 48",
            "17  AppKit                              0x00007fff819e504b _DPSNextEvent + 1205",
            "18  AppKit                              0x00007fff819e47a9 -[NSApplication nextEventMatchingMask:untilDate:inMode:dequeue:] + 155",
            "19  AppKit                              0x00007fff819aa48b -[NSApplication run] + 395",
            "20  AppKit                              0x00007fff819a31a8 NSApplicationMain + 364",
            "21  ErrorTest                           0x0000000100001012 main + 34",
            "22  ErrorTest                           0x0000000100000fe4 start + 52",
            "23  ???                                 0x0000000000000001 0x0 + 1"
        );
    }

##Example Usage for iOS
Using the following code in an iOS application's app delegate running on an iPhone 4 device:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
     
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
    
        NSError *error = [TIUError errorWithCode:1 domain:@"com.timisted.errors" localizedDescription:@"Test error"];
    
        NSLog(@"%@", error);
    
        return YES;
    }

yields the following output in the console:

    Error Domain=com.timisted.errors Code=1 "Test error" UserInfo=0x140d20 {kTIUErrorStackTraceKey=(
        "0   ErrorTestiPhone                     0x000034d7 +[TIUError errorWithCode:domain:localizedDescription:underlyingError:userInfo:] + 282",
        "1   ErrorTestiPhone                     0x000032b7 +[TIUError errorWithCode:domain:localizedDescription:] + 82",
        "2   ErrorTestiPhone                     0x00002f83 -[ErrorTestiPhoneAppDelegate application:didFinishLaunchingWithOptions:] + 154",
        "3   UIKit                               0x3209ebc5 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 772",
        "4   UIKit                               0x3209a259 -[UIApplication _runWithURL:payload:launchOrientation:statusBarStyle:statusBarHidden:] + 272",
        "5   UIKit                               0x3206648b -[UIApplication handleEvent:withNewEvent:] + 1114",
        "6   UIKit                               0x32065ec9 -[UIApplication sendEvent:] + 44",
        "7   UIKit                               0x32065907 _UIApplicationHandleEvent + 5090",
        "8   GraphicsServices                    0x33b0ef03 PurpleEventCallback + 666",
        "9   CoreFoundation                      0x33a556ff __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__ + 26",
        "10  CoreFoundation                      0x33a556c3 __CFRunLoopDoSource1 + 166",
        "11  CoreFoundation                      0x33a47f7d __CFRunLoopRun + 520",
        "12  CoreFoundation                      0x33a47c87 CFRunLoopRunSpecific + 230",
        "13  CoreFoundation                      0x33a47b8f CFRunLoopRunInMode + 58",
        "14  UIKit                               0x32099309 -[UIApplication _run] + 380",
        "15  UIKit                               0x32096e93 UIApplicationMain + 670",
        "16  ErrorTestiPhone                     0x00002ea7 main + 82",
        "17  ErrorTestiPhone                     0x00002e50 start + 40"
    ), NSLocalizedDescription=Test error}

##User Info Dictionary Keys

The following keys are used in the user info dictionary:

* `NSLocalizedDescriptionKey`, the standard key for the localized description.
* `kTIUErrorUnderlyingErrorKey` for the underlying error, if one is provided.
* `kTIUErrorStackTraceKey` for the stack trace.