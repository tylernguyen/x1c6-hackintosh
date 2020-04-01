//
//  main.m
//  ALCPlugFix
//
//  Created by Oleksandr Stoyevskyy on 11/3/16.
//  Copyright © 2016 Oleksandr Stoyevskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <AppKit/AppKit.h>


void fixAudio();
NSString *binPrefix;

@protocol DaemonProtocol
- (void)performWork;
@end

@interface NSString (ShellExecution)
- (NSString*)runAsCommand;
@end

@implementation NSString (ShellExecution)

- (NSString*)runAsCommand {
    NSPipe* pipe = [NSPipe pipe];

    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];

    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];

    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

@end

# pragma mark ALCPlugFix Object Conforms to Protocol

@interface ALCPlugFix : NSObject <DaemonProtocol>
@end;
@implementation ALCPlugFix
- (id)init
{
    self = [super init];
    if (self) {
        // Do here what you needs to be done to start things
        
        // sleep wake
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: NSWorkspaceDidWakeNotification object: nil];
        // screen unlock
        [[NSDistributedNotificationCenter defaultCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: @"com.apple.screenIsUnlocked" object: nil];
        // screen saver end
        [[NSDistributedNotificationCenter defaultCenter] addObserver: self
                                                            selector: @selector(receiveWakeNote:)
                                                                name: @"com.apple.screensaver.didstop" object: nil];
        // Screen wake
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: NSWorkspaceScreensDidWakeNotification object: nil];
        // Switch to other user
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: NSWorkspaceSessionDidResignActiveNotification object: nil];
        // Switch back to current user
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(receiveWakeNote:)
                                                                   name: NSWorkspaceSessionDidBecomeActiveNotification object: nil];
    }
    return self;
}


- (void)dealloc
{
    // Do here what needs to be done to shut things down
    //[super dealloc];
}

- (void)performWork
{
    // This method is called periodically to perform some routine work
    NSLog(@"Performing periodical work");
//    fixAudio();

}
- (void) receiveWakeNote: (NSNotification*) note
{
    NSLog(@"receiveSleepNote: %@", [note name]);
    NSLog(@"Wake detected");
    fixAudio();
}


@end

# pragma mark Setup the daemon

// Seconds runloop runs before performing work in second.
#define kRunLoopWaitTime 14400.0 // 4hour

BOOL keepRunning = TRUE;
CFRunLoopRef runLoopRef;

void sigHandler(int signo)
{
    NSLog(@"sigHandler: Received signal %d", signo);

    switch (signo) {
        case SIGTERM:
        case SIGKILL:
        case SIGQUIT:
        case SIGHUP:
        case SIGINT:
            // Now handle more signal to quit
            NSLog(@"Exiting...");
            keepRunning = FALSE;
            CFRunLoopStop(CFRunLoopGetCurrent()); // Kill current thread so we don't need to wait until next runloop call
            break;
        default:
            break;
    }
}

void fixAudio(){
    NSLog(@"Fixing...");
    NSString *output1 = [[binPrefix stringByAppendingString:@"hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x25"] runAsCommand];
    NSString *output2 = [[binPrefix stringByAppendingString:@"hda-verb 0x21 SET_UNSOLICITED_ENABLE 0x33"] runAsCommand];
}





int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSLog(@"ALCPlugFix v1.6");
        keepRunning = false;

        binPrefix = @"";

        signal(SIGHUP, sigHandler);
        signal(SIGTERM, sigHandler);
        signal(SIGKILL, sigHandler);
        signal(SIGQUIT, sigHandler);
        signal(SIGINT, sigHandler);

        ALCPlugFix *task = [[ALCPlugFix alloc] init];

        // Check hda-verb location
        NSFileManager *filemgr;
        filemgr = [[NSFileManager alloc] init];

        if ([filemgr fileExistsAtPath:@"./hda-verb"]){
            // hda-verb at work dir
            NSLog(@"Found had-verb in work dir");
            binPrefix = [filemgr.currentDirectoryPath stringByAppendingString:@"/"];
        }else
            NSLog(@"Current Directory %@", filemgr.currentDirectoryPath);

        NSLog(@"Headphones daemon running!");
        // Audio Listener setup
        AudioDeviceID defaultDevice = 0;
        UInt32 defaultSize = sizeof(AudioDeviceID);

        const AudioObjectPropertyAddress defaultAddr = {
            kAudioHardwarePropertyDefaultOutputDevice,
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster
        };


        AudioObjectPropertyAddress sourceAddr;
        sourceAddr.mSelector = kAudioDevicePropertyDataSource;
        sourceAddr.mScope = kAudioDevicePropertyScopeOutput;
        sourceAddr.mElement = kAudioObjectPropertyElementMaster;

        AudioObjectPropertyListenerBlock audioObjectPropertyListenerBlock = ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress *inAddresses) {
            // Audio device have changed
            NSLog(@"Audio device changed!");
            fixAudio();
        };

        OSStatus osStatus;

        do {
            AudioObjectGetPropertyData(kAudioObjectSystemObject, &defaultAddr, 0, NULL, &defaultSize, &defaultDevice);
            osStatus = AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddr, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), audioObjectPropertyListenerBlock);

            if (osStatus != 0){
                // OS Status 560947818 is 'normal' as we are trying to hook audio object before login screen.
                NSLog(@"ERROR: Something went wrong! Failed to add Audio Listener!");
                NSLog(@"OS Status: %d",osStatus);
                NSLog(@"Waiting 7 second");
                sleep(7);
            } else
                NSLog(@"Correctly added Audio Listener!");

        }while(osStatus!=0);

        // Fix at boot
        fixAudio();
        do{
            [task performWork];
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, kRunLoopWaitTime, false);
        }while (keepRunning);
//        [task release];

        OSStatus removeStatus = AudioObjectRemovePropertyListenerBlock(defaultDevice, &sourceAddr, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),audioObjectPropertyListenerBlock);
        NSLog(@"Listener removed with status: %d",removeStatus);
        NSLog(@"Daemon exited");
    }
    return 0;
}
