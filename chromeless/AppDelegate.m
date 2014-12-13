//
//  AppDelegate.m
//  chromeless
//
//  Created by Matthew Jee on 9/30/14.
//  Copyright (c) 2014 marmphco. All rights reserved.
//

#import "AppDelegate.h"
#import "AVFoundation/AVFoundation.h"

@interface AppDelegate ()

@property (strong) NSMutableArray *windows;
@property (strong) NSWindow *hugeWindow;
@property (strong) AVAudioPlayer *audioPlayer;
@property (strong) AVAudioPlayer *urtooslow;

@property (assign) int screenWidth;
@property (assign) int screenHeight;

@end

@implementation AppDelegate

- (NSWindow *)makeSanicWithWidth:(int)width height:(int)height {
    NSRect rect = NSRectFromCGRect(CGRectMake(0, 0, width, height));
    NSWindow *window = [[NSWindow alloc] initWithContentRect:rect
                                                   styleMask:NSBorderlessWindowMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:YES];
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:[[window contentView] bounds]];
    [imageView setImage:[NSImage imageNamed:@"sanic"]];
    [[window contentView] addSubview:imageView];
    return window;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.screenWidth = [[NSScreen mainScreen] frame].size.width;
    self.screenHeight = [[NSScreen mainScreen] frame].size.height;
    
    self.windows = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        NSWindow *window = [self makeSanicWithWidth:200 height:200];
        [self.windows addObject:window];
    }
    
    self.hugeWindow = [self makeSanicWithWidth:800 height:800];
    [self.hugeWindow setFrameOrigin:CGPointMake(-799, 0)];

    NSError *error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sanic" withExtension:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.audioPlayer setNumberOfLoops:-1];
    [self.audioPlayer play];
    
    url = [[NSBundle mainBundle] URLForResource:@"urtooslow" withExtension:@"mp3"];
    self.urtooslow = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.urtooslow setNumberOfLoops:-1];
    [self.urtooslow play];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sanic:) userInfo:nil repeats:YES];
}

- (void)sanic:(NSTimer *)timer {
    for (int i = 0; i < 20; i++) {
        NSWindow *window = [self.windows objectAtIndex:i];
        [window setFrameOrigin:CGPointMake((float)rand() * self.screenWidth / RAND_MAX, (float)rand() * self.screenHeight / RAND_MAX)];
        [window makeKeyAndOrderFront:self];
    }
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    // move huge sanic
    if (self.hugeWindow.frame.origin.x < self.screenWidth / 2.0) {
        [self.hugeWindow setFrameOrigin:CGPointMake(self.hugeWindow.frame.origin.x + 10, self.hugeWindow.frame.origin.y)];
    }
    [self.hugeWindow makeKeyAndOrderFront:self];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
