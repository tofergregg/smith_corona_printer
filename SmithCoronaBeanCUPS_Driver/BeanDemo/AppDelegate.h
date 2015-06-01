//
//  AppDelegate.h
//  BeanDemo
//
//  Created by Chris Gregg on 6/13/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//
//  The LightBlue Bean can be found here:
//  http://punchthrough.com/bean/
//
//  The libBean SDK can be found here:
//  https://github.com/PunchThrough/Bean-iOS-OSX-SDK


#import <Cocoa/Cocoa.h>
#import "PTDBean.h"
#import "PTDBeanManager.h"
#import "PTDBeanRadioConfig.h"
#import "BEAN_Globals.h"

#define connectedCheck @"✅"
#define disconnectedX @"❌"

#define BEAN_NAME @"SmithCoronaBean"

@interface AppDelegate : NSObject <NSApplicationDelegate, PTDBeanManagerDelegate, PTDBeanDelegate, NSTableViewDataSource> {
        NSLock *threadLock;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *scanSheet;
@property (retain) PTDBeanManager *beanManager;
@property (assign) IBOutlet NSTableView *scanTable;
@property (retain) NSMutableArray *beans; // the BLE devices we find
@property (retain) PTDBean *bean;
@property (weak) NSTimer *updateTimer;
@property (retain) IBOutlet NSProgressIndicator *connectionProgress;
@property (retain) IBOutlet NSTextField *connectedLabel;
@property (retain) IBOutlet NSTextField *beanStatusLabel;
@property int timeStep;
@property (assign) IBOutlet NSTextView *textToSend;
@property (assign) IBOutlet NSButton *sendButton;

@property (nonatomic,retain) NSMutableArray* byteQueue;

- (void) openScanSheet;
- (IBAction) closeScanSheet:(id)sender;
- (IBAction) cancelScanSheet:(id)sender;
- (IBAction) newConnectionMenu:(id)sender;
- (IBAction) disconnect:(id)sender;

- (void) setAll;
- (IBAction) sendText:(id)sender;
- (void) addCharToSerialQueue:(char)oneChar;

- (void) addStringToSerialQueue:(NSString *)str;
- (void) sendSpecialCommand:(NSString *)str;
- (void) sendSerialByte;
- (NSString *)replaceForTypewriter:(NSString *)str;
- (void)updateAll;

@end
