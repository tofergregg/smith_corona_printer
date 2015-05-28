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
@synthesize SRCLR,G,RCK,SRCK,SER_IN,SHIFT,LED;
@synthesize byteQueue;
@synthesize textToSend;
@synthesize beginRange,endRange;

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
        // populate initial text box
        textToSend.string = @"Hello, World!\n";
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
- (IBAction) toggleSRCLR:(id)sender {
        //NSLog(@"SRCLR pressed");
        if ([SRCLR.stringValue isEqual: @"LOW"]) {
                // NSLog(@"Changing to HIGH");
                [self sendSpecialCommand:@"a"];
                SRCLR.stringValue = @"HIGH";
        }
        else {
                // NSLog(@"Changing to LOW");
                [self sendSpecialCommand:@"b"];
                SRCLR.stringValue = @"LOW";
        }
        
}
- (IBAction) toggleG:(id)sender {
        if ([G.stringValue isEqual: @"LOW"]) {
                // NSLog(@"Changing to HIGH");
                [self sendSpecialCommand:@"c"];
                G.stringValue = @"HIGH";
        }
        else {
                // NSLog(@"Changing to LOW");
                [self sendSpecialCommand:@"d"];
                G.stringValue = @"LOW";
        }
}
- (IBAction) toggleRCK:(id)sender {
        if ([RCK.stringValue isEqual: @"LOW"]) {
                // NSLog(@"Changing to HIGH");
                [self sendSpecialCommand:@"e"];
                RCK.stringValue = @"HIGH";
        }
        else {
                // NSLog(@"Changing to LOW");
                [self sendSpecialCommand:@"f"];
                RCK.stringValue = @"LOW";
        }
        
}
- (IBAction) toggleSRCK:(id)sender {
        if ([SRCK.stringValue isEqual: @"LOW"]) {
                // NSLog(@"Changing to HIGH");
                [self sendSpecialCommand:@"g"];
                SRCK.stringValue = @"HIGH";
        }
        else {
                // NSLog(@"Changing to LOW");
                [self sendSpecialCommand:@"h"];
                SRCK.stringValue = @"LOW";
        }
}
- (IBAction) toggleSER_IN:(id)sender {
        if ([SER_IN.stringValue isEqual: @"0"]) {
                // NSLog(@"Changing to 1");
                [self sendSpecialCommand:@"i"];
                SER_IN.stringValue = @"1";
        }
        else {
                // NSLog(@"Changing to 0");
                [self sendSpecialCommand:@"j"];
                SER_IN.stringValue = @"0";
        }
        
}
- (IBAction) toggleSHIFT:(id)sender {
        if ([SHIFT.stringValue isEqual: @"OFF"]) {
                // NSLog(@"Changing to ON");
                [self sendSpecialCommand:@"k"];
                SHIFT.stringValue = @"ON";
        }
        else {
                // NSLog(@"Changing to OFF");
                [self sendSpecialCommand:@"l"];
                SHIFT.stringValue = @"OFF";
        }
        
}
- (IBAction) toggleLED:(id)sender {
        if ([LED.stringValue isEqual: @"OFF"]) {
                // NSLog(@"Changing to ON");
                [self sendSpecialCommand:@"m"];
                LED.stringValue = @"ON";
        }
        else {
                // NSLog(@"Changing to OFF");
                [self sendSpecialCommand:@"n"];
                LED.stringValue = @"OFF";
        }
}

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
        if ([SRCLR.stringValue isEqual: @"HIGH"]) {
                [self sendSpecialCommand:@"a"];
        }
        else {
                [self sendSpecialCommand:@"b"];
        }
        
        if ([G.stringValue isEqual: @"HIGH"]) {
                [self sendSpecialCommand:@"c"];
        }
        else {
                [self sendSpecialCommand:@"d"];
        }
        
        if ([RCK.stringValue isEqual: @"HIGH"]) {
                [self sendSpecialCommand:@"e"];
        }
        else {
                [self sendSpecialCommand:@"f"];
        }
        
        if ([SRCK.stringValue isEqual: @"HIGH"]) {
                [self sendSpecialCommand:@"g"];
        }
        else {
                [self sendSpecialCommand:@"h"];
        }
        
        if ([SER_IN.stringValue isEqual: @"1"]) {
                [self sendSpecialCommand:@"i"];
        }
        else {
                [self sendSpecialCommand:@"j"];
        }
        
        if ([SHIFT.stringValue isEqual: @"OFF"]) {
                [self sendSpecialCommand:@"k"];
        }
        else {
                [self sendSpecialCommand:@"l"];
        }
        
}

- (IBAction) clearAll:(id)sender {
        // set SRCLR low then high
        [self sendSpecialCommand:@"b"];
        [self sendSpecialCommand:@"a"];
        
        // set RCK high then low
        [self sendSpecialCommand:@"e"];
        [self sendSpecialCommand:@"f"];
}

- (IBAction) sendKeystroke:(id)sender {
        // set G to low (send keystroke)
        [self sendSpecialCommand:@"d"];
        G.stringValue = @"LOW";
        
        // set G to high (stop sending keystroke)
        [self sendSpecialCommand:@"c"];
        G.stringValue = @"HIGH";
}

- (IBAction) test8:(id)sender {
        // test all 8 keystrokes on the first shift register
        // set G high for good measure
        [self sendSpecialCommand:@"c"];
        
        // send the following keys:
        // 59763482
        
        [self addStringToSerialQueue:@"59763482"];
        
}

- (IBAction) sendText:(id)sender {
        // send the text from textToSend
        [self addStringToSerialQueue:textToSend.string];
}

- (IBAction) sendRange:(id)sender {
        int begin = (int)beginRange.integerValue;
        int end = (int)endRange.integerValue;
        if (begin < 0 || begin > 48) return;
        if (end < 0 || end > 48) return;
        if (end < begin) return;
        // send a character to Bean to expect a range
        [self sendSpecialCommand:@"o+127"];
        // now send the two range values
        [self addCharToSerialQueue:begin];
        [self addCharToSerialQueue:end];
}


- (void) setBit:(int)bit {
        // input: a number between 0 and 47
        /*
        // clears first
        // then sets a particular bit by shifting in zeros then the bit
        
        // clear
        //[self sendSpecialCommand:@"baef"];
        [self clearAll:self];
        
        // first, shift a 1
        [self shiftOne:self];
        
        // now shift 48-bit number of zeros
        for (int i=0;i<bit;i++) {
                [self shiftZero:self];
        }*/
        // need to send bit+1 so we actually send a byte (zero doesn't get sent?)
        [self addStringToSerialQueue:[NSString stringWithFormat:@"%c",bit+1]];
}

- (void) sendSpecialCommand:(NSString *)str {
        // add 127 to command (legacy)
        unsigned char specialChar = [str characterAtIndex:0]+127;
        
        NSData *data = [NSData dataWithBytes:&specialChar length:1];
        
        [byteQueue addObject:data];
}

- (NSString *)replaceForTypewriter:(NSString *)str {
        NSString *allowedChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ234567890@#$%¢&*()-_¼½:;'\".,/? \n";
        
        NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:allowedChars];
        

        // replace the following characters:
        // 1 with l
        // ‘ with '
        // ’ with '
        // ` with '
        // ” with "
        // ‟ with "

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
                NSLog(@"Finding New Beans");
                
                [threadLock lock]; // NSMutableArray isn't thread-safe
                if ([beans count]) [self.beans removeAllObjects];
                [scanTable reloadData];
                [threadLock unlock];


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
        //[self.beanManager connectToBean:bean error:nil];
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
        
        // set up pins based on window
        [self setAll];
        
}

- (void)BeanManager:(PTDBeanManager*)beanManager didDisconnectBean:(PTDBean*)bean error:(NSError*)error {
        NSLog(@"Bean disconnected.");
        [connectedLabel setStringValue:disconnectedX];
}

/*
 Open scan sheet to discover Bean peripheral if it is LE capable hardware
 */
- (void) openScanSheet
{

        [NSApp beginSheet:self.scanSheet modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [self.beanManager startScanningForBeans_error:nil];
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
