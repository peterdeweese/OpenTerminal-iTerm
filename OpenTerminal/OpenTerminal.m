//
//  OpenTerminal.m
//  OpenTerminal
//
//  Created by Ronan on 07/09/2013.
//  Copyright (c) 2013 Mobile Genius LLC. All rights reserved.
//

#import "OpenTerminal.h"


@interface OpenTerminal()
- (void) open;
@end

@implementation OpenTerminal

static OpenTerminal *mySharedPlugin = nil;

+(void)pluginDidLoad:(NSBundle *)plugin
{
	NSLog(@"OpenTerminal-iTerm Xcode plugin loaded!");
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedPlugin = [self new]; });
}

+(OpenTerminal *)sharedPlugin
{
	return mySharedPlugin;
}

- (void)addMenuItem
{
    NSMenuItem *viewMenuItem = [[NSApp mainMenu] itemWithTitle:@"File"];
    if (viewMenuItem)
    {
        [viewMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *openTerminalItem = [[NSMenuItem alloc] initWithTitle:@"Open Project in iTerm" action:@selector(open) keyEquivalent:@"t"];
        openTerminalItem.keyEquivalentModifierMask = NSAlternateKeyMask | NSCommandKeyMask;
        openTerminalItem.target = self;
        [viewMenuItem.submenu addItem:openTerminalItem];
    }
}

- (id)init
{
    if (self = [super init])
        [self addMenuItem];
        
    return self;
}

- (void) open
{
    NSMutableDictionary *errorDict = nil;
    NSBundle *myBundle = [NSBundle bundleForClass: self.class];
    NSString *path = [myBundle pathForResource:@"openTerminal" ofType:@"txt"];
    NSData *scriptData = [NSData dataWithContentsOfFile:path];
    NSString *sourceString = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
    NSAppleScript *aScript = [[NSAppleScript alloc] initWithSource:sourceString];
    
    [aScript executeAndReturnError:&errorDict];
    if (errorDict)
        NSLog(@"Error running code: %@", errorDict.description);
}


@end
