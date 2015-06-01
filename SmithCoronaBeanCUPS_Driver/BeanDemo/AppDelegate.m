//
//  AppDelegate.m
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

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize beanManager,bean,beans;
@synthesize updateTimer,connectionProgress,connectedLabel;
@synthesize timeStep;
@synthesize scanTable;
@synthesize byteQueue;
@synthesize textToSend;
@synthesize beanStatusLabel;
@synthesize sendButton;

- (void)awakeFromNib {

}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
        // create the bean and assign ourselves as the delegate
        threadLock = [[NSLock alloc] init]; // lock for the bean

        self.beans = [NSMutableArray array];
        self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
        
        self.bean = nil;
        self.updateTimer = nil;
        timeStep = 0;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:3];
        
        // set up byteQueue
        byteQueue = [[NSMutableArray alloc] init];
        
        
        // set up timer to send bytes to bean every 50ms seconds
        [NSTimer scheduledTimerWithTimeInterval:0.001
                                         target:self
                                       selector:@selector(sendSerialByte)
                                       userInfo:nil
                                        repeats:YES];
        // populate initial text box with text from first argument's file
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    
    NSString *fileText = [[NSString alloc] initWithContentsOfFile:[arguments objectAtIndex:1] encoding:NSUTF8StringEncoding error:nil];
    
        textToSend.string = fileText;
    
}

/*
 Disconnect peripheral when application terminate
 */
- (void) applicationWillTerminate:(NSNotification *)notification
{
        if(self.bean)
        {
                [beanManager disconnectBean:bean error:nil];
                //NSLog(@"Sent message to cancel bean.");
                //[NSThread sleepForTimeInterval:1];
        }
}

// button presses

- (void) shiftBit {
        // NSLog(@"Changing SRCK to HIGH");
        [self sendSpecialCommand:@"g"];
        
        // NSLog(@"Changing SRCK to LOW");
        [self sendSpecialCommand:@"h"];
        
        // NSLog(@"Changing RCK to HIGH");
        [self sendSpecialCommand:@"e"];
        
        // NSLog(@"Changing RCK to LOW");
        [self sendSpecialCommand:@"f"];
}

- (IBAction)shiftZero:(id)sender {
        // NSLog(@"Changing to 0");
        [self sendSpecialCommand:@"j"];
        [self shiftBit];
}

- (IBAction)shiftOne:(id)sender {
        // NSLog(@"Changing to 1");
        [self sendSpecialCommand:@"i"];
        [self shiftBit];
}

- (void) setAll {
    
                // SRCLR high
                [self sendSpecialCommand:@"a"];
    
                // _G high
                [self sendSpecialCommand:@"c"];
        
    
                // RCK low
                [self sendSpecialCommand:@"f"];
    
                // SRCK low
                [self sendSpecialCommand:@"h"];
    
                // SER_IN 0
                [self sendSpecialCommand:@"j"];
    
                // SHIFT 0
                [self sendSpecialCommand:@"k"];
}

- (IBAction) clearAll:(id)sender {
        // set SRCLR low then high
        [self sendSpecialCommand:@"b"];
        [self sendSpecialCommand:@"a"];
        
        // set RCK high then low
        [self sendSpecialCommand:@"e"];
        [self sendSpecialCommand:@"f"];
}

- (IBAction) sendText:(id)sender {
        // send the text from textToSend
        [self addStringToSerialQueue:textToSend.string];
}

- (void) sendSpecialCommand:(NSString *)str {
        // add 127 to command (legacy)
        unsigned char specialChar = [str characterAtIndex:0]+127;
        
        NSData *data = [NSData dataWithBytes:&specialChar length:1];
        
        [byteQueue addObject:data];
}

- (NSString *)replaceForTypewriter:(NSString *)str {
        NSString *allowedChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ234567890@#$%¢&*()-_¼½:;'\".,/?! \n";
        
        NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:allowedChars];
        

        // replace the following characters:
        // 1 with l
        // ‘ with '
        // ’ with '
        // ` with '
        // ” with "
        // ‟ with "
        // "…" with "..."
        // "—" with "--"

        // All other characters should be replaced
        // with a space
        NSMutableString *newStr = [[NSMutableString alloc] init];
        [newStr setString:str];
        
        [newStr replaceOccurrencesOfString:@"1"withString:@"l" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"‘"withString:@"'" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"’"withString:@"'" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"`"withString:@"'" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"“"withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"”"withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"…"withString:@"..." options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        [newStr replaceOccurrencesOfString:@"—"withString:@"--" options:NSLiteralSearch range:NSMakeRange(0,[newStr length])];
        
        // now walk through the entire string and change non-
        // printable characters to spaces
        for (int i=0;i<[newStr length];i++) {
                unichar c = [newStr characterAtIndex:i];
                if (![allowedCharacterSet characterIsMember:c]) {
                        [newStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@" "];
                }
        }
        
        NSLog(@"typewriter compatible string:%@",newStr);
        
        return [NSString stringWithString:newStr];
}

// add a string of characters to the serial queue
- (void) addStringToSerialQueue:(NSString *)str {
        // adds each character to the queue, one after another
        // first, replace non-ascii characters
        str = [self replaceForTypewriter:str];
        for (uint i=0;i<[str length];i++) {
                unsigned char oneChar = [str characterAtIndex:i];
                NSData *data = [NSData dataWithBytes:&oneChar length:1];
                [byteQueue addObject:data];
        }
}

- (void) addCharToSerialQueue:(char)oneChar {
        // adds a raw character to send
        NSData *data = [NSData dataWithBytes:&oneChar length:1];
        [byteQueue addObject:data];
}

// send a serial byte and wait to send the next one
- (void) sendSerialByte {
        if ([byteQueue count] > 0) {
                NSData *aByte = [byteQueue objectAtIndex:0];
                [byteQueue removeObjectAtIndex:0];
                [self.bean sendSerialData:aByte];
                NSLog(@"Sent:%@",aByte);
        }
}

/*
 This method is called when connect button pressed and it takes appropriate actions depending on device connection state
 */
- (IBAction)newConnectionMenu:(id)sender
{
        if (bean.state != BeanState_ConnectedAndValidated) {
                if(self.beanManager.state == BeanManagerState_PoweredOn){
                        // if we're on, scan for advertisting beans
                        [self openScanSheet];
                }
                else if (self.beanManager.state == BeanManagerState_PoweredOff) {
                        // probably should have an error message here
                }
        }
}

// check to make sure we're on
- (void)beanManagerDidUpdateState:(PTDBeanManager *)manager{
    NSLog(@"Bean Manager is on!");
    // start searching for beans
    if (bean.state != BeanState_ConnectedAndValidated) {
        NSLog(@"Finding New Beans");
        
        [threadLock lock]; // NSMutableArray isn't thread-safe
        if ([beans count]) [self.beans removeAllObjects];
        [scanTable reloadData];
        [threadLock unlock];
        
        [self.beanManager startScanningForBeans_error:nil];
    }

}
// bean discovered
- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)aBean error:(NSError*)error{
        if (error) {
                PTDLog(@"%@", [error localizedDescription]);
                return;
        }
        if( ![self.beans containsObject:aBean] ){
                NSLog(@"Name: '%@',%ld",[aBean name],[self.beans count]);

                [self.beans addObject:aBean];
        }
        [self.scanTable reloadData];
        NSLog(@"Updated Bean in Scan Window: %@",[((PTDBean *)self.beans[0]) name]);
    
        // if we have found the correct bean, connect!
        if ([ [aBean name] isEqualTo:BEAN_NAME]) {
            self.bean = aBean;
            [connectedLabel setStringValue:@""];
            [connectionProgress startAnimation:self];
            [self.beanManager connectToBean:aBean error:nil];
        }
}
// bean connected
- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error{
        if (error) {
                PTDLog(@"%@", [error localizedDescription]);
                return;
        }
        // do stuff with your bean
        NSLog(@"Bean connected!");
        [connectionProgress stopAnimation:self];
        [connectedLabel setStringValue:connectedCheck];
        [sendButton setEnabled:YES];
    
        [beanStatusLabel setStringValue:@""];
    
        // set up pins based on window
        [self setAll];
        
}

- (void)BeanManager:(PTDBeanManager*)beanManager didDisconnectBean:(PTDBean*)bean error:(NSError*)error {
        NSLog(@"Bean disconnected.");
        [connectedLabel setStringValue:disconnectedX];
        [sendButton setEnabled:NO];
}

/*
 Open scan sheet to discover Bean peripheral if it is LE capable hardware
 */
- (void) openScanSheet
{

        [NSApp beginSheet:self.scanSheet modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

/*
 Close scan sheet once device is selected
 */
- (IBAction)closeScanSheet:(id)sender
{
        [NSApp endSheet:self.scanSheet returnCode:NSAlertDefaultReturn];
        [self.scanSheet orderOut:self];
}

/*
 This method is called when Scan sheet is closed. Initiate connection to selected heart rate peripheral
 */
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
        [self.beanManager stopScanningForBeans_error:nil];
        if( returnCode == NSAlertDefaultReturn )
        {
                NSInteger selectedRow = [self.scanTable selectedRow];
                if (selectedRow != -1)
                {
                        self.bean = [self.beans objectAtIndex:selectedRow];
                        self.bean.delegate = self;
                        [connectedLabel setStringValue:@""];
                        [connectionProgress startAnimation:self];
                        [self.beanManager connectToBean:bean error:nil];
                        [self.updateTimer invalidate];
                        
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                                          target:self selector:@selector(updateAll)
                                                                        userInfo:nil repeats:YES];
                        self.updateTimer = timer;
                }
        }
}

/*
 Close scan sheet without choosing any device
 */
- (IBAction)cancelScanSheet:(id)sender
{
        [self.beanManager stopScanningForBeans_error:nil];
        [NSApp endSheet:self.scanSheet returnCode:NSAlertAlternateReturn];
        [self.scanSheet orderOut:self];
}

#pragma mark tableview methods
// must handle both tables in the interface
// ScratchTable, ScanTable

- (id) tableView:(NSTableView *) aTableView
        objectValueForTableColumn:(NSTableColumn *) aTableColumn
                              row:(NSInteger) rowIndex
{
        return [[self.beans objectAtIndex:rowIndex] name];
}

// just returns the number of items we have.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
        if ([aTableView isEqualTo:scanTable]) {
                return [self.beans count];
        }
        else { // scratchTable
                return 5; // five scratch registers
        }
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
        }

// oddly, we seem to have to do the text coloring twice...
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
}
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        NSTextFieldCell *cell = [tableColumn dataCell];

        return cell;
}

-(void)bean:(PTDBean*)bean didUpdateTemperature:(NSNumber*)degrees_celsius {

}

- (void)updateAll {
}

- (IBAction)disconnect:(id)sender {
        
        [threadLock lock]; // Must invalidate timer in a lock?
        [self.updateTimer invalidate];
        [threadLock unlock];

        [beanManager disconnectBean:bean error:nil];
}

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data {
        // will receive a bunch of bytes
        NSString* bytesReceived;
        
        bytesReceived = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        unsigned char byteRecd = [bytesReceived characterAtIndex:0];
        
        if (byteRecd > 127) {
                byteRecd = byteRecd-127;
                NSLog(@"Special Byte received: %d",byteRecd+127);
        }
        else {
                NSLog(@"Byte received:");
        
                switch (byteRecd) {
                        case 'a':
                                NSLog(@"%@",@"SRCLR High");
                                break;
                        case 'b':
                                NSLog(@"%@",@"SRCLR Low");
                                break;

                        case 'c':
                                NSLog(@"%@",@"G High");
                                break;

                        case 'd':
                                NSLog(@"%@",@"G Low");
                                break;

                        case 'e':
                                NSLog(@"%@",@"RCK High");
                                break;

                        case 'f':
                                NSLog(@"%@",@"RCK Low");
                                break;

                        case 'g':
                                NSLog(@"%@",@"SRCK High");
                                break;

                        case 'h':
                                NSLog(@"%@",@"SRCK Low");
                                break;

                        case 'i':
                                NSLog(@"%@",@"SER IN 1");
                                break;

                        case 'j':
                                NSLog(@"%@",@"SER IN 0");
                                break;

                        case 'k':
                                NSLog(@"%@",@"SHIFT ON");
                                break;

                        case 'l':
                                NSLog(@"%@",@"SHIFT OFF");
                                break;

                        default:
                                NSLog(@"%c",byteRecd);
                }
        }
        //NSLog(@"Received from Bean:%@",bytesReceived);
        
}

@end
