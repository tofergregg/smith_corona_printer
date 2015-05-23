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
        NSLog(@"SRCLR pressed");
        if ([SRCLR.stringValue isEqual: @"LOW"]) {
                NSLog(@"Changing to HIGH");
                [bean sendSerialString:@"a"];
                SRCLR.stringValue = @"HIGH";
        }
        else {
                NSLog(@"Changing to LOW");
                [bean sendSerialString:@"b"];
                SRCLR.stringValue = @"LOW";
        }
        
}
- (IBAction) toggleG:(id)sender {
        if ([G.stringValue isEqual: @"LOW"]) {
                NSLog(@"Changing to HIGH");
                [bean sendSerialString:@"c"];
                G.stringValue = @"HIGH";
        }
        else {
                NSLog(@"Changing to LOW");
                [bean sendSerialString:@"d"];
                G.stringValue = @"LOW";
        }
}
- (IBAction) toggleRCK:(id)sender {
        if ([RCK.stringValue isEqual: @"LOW"]) {
                NSLog(@"Changing to HIGH");
                [bean sendSerialString:@"e"];
                RCK.stringValue = @"HIGH";
        }
        else {
                NSLog(@"Changing to LOW");
                [bean sendSerialString:@"f"];
                RCK.stringValue = @"LOW";
        }
        
}
- (IBAction) toggleSRCK:(id)sender {
        if ([SRCK.stringValue isEqual: @"LOW"]) {
                NSLog(@"Changing to HIGH");
                [bean sendSerialString:@"g"];
                SRCK.stringValue = @"HIGH";
        }
        else {
                NSLog(@"Changing to LOW");
                [bean sendSerialString:@"h"];
                SRCK.stringValue = @"LOW";
        }
}
- (IBAction) toggleSER_IN:(id)sender {
        if ([SER_IN.stringValue isEqual: @"0"]) {
                NSLog(@"Changing to 1");
                [bean sendSerialString:@"i"];
                SER_IN.stringValue = @"1";
        }
        else {
                NSLog(@"Changing to 0");
                [bean sendSerialString:@"j"];
                SER_IN.stringValue = @"0";
        }
        
}
- (IBAction) toggleSHIFT:(id)sender {
        if ([SHIFT.stringValue isEqual: @"OFF"]) {
                NSLog(@"Changing to ON");
                [bean sendSerialString:@"k"];
                SHIFT.stringValue = @"ON";
        }
        else {
                NSLog(@"Changing to OFF");
                [bean sendSerialString:@"l"];
                SHIFT.stringValue = @"OFF";
        }
        
}
- (IBAction) toggleLED:(id)sender {
        if ([LED.stringValue isEqual: @"OFF"]) {
                NSLog(@"Changing to ON");
                [bean sendSerialString:@"m"];
                LED.stringValue = @"ON";
        }
        else {
                NSLog(@"Changing to OFF");
                [bean sendSerialString:@"n"];
                LED.stringValue = @"OFF";
        }
}

- (void) shiftBit {
        NSLog(@"Changing SRCK to HIGH");
        [bean sendSerialString:@"g"];
        
        NSLog(@"Changing SRCK to LOW");
        [bean sendSerialString:@"h"];
        
        NSLog(@"Changing RCK to HIGH");
        [bean sendSerialString:@"e"];
        
        NSLog(@"Changing RCK to LOW");
        [bean sendSerialString:@"f"];
}

- (IBAction)shiftZero:(id)sender {
        NSLog(@"Changing to 0");
        [bean sendSerialString:@"j"];
        [self shiftBit];
}

- (IBAction)shiftOne:(id)sender {
        NSLog(@"Changing to 1");
        [bean sendSerialString:@"i"];
        [self shiftBit];
}

- (void) setAll {
        if ([SRCLR.stringValue isEqual: @"HIGH"]) {
                [bean sendSerialString:@"a"];
        }
        else {
                [bean sendSerialString:@"b"];
        }
        
        if ([G.stringValue isEqual: @"HIGH"]) {
                [bean sendSerialString:@"c"];
        }
        else {
                [bean sendSerialString:@"d"];
        }
        
        if ([RCK.stringValue isEqual: @"HIGH"]) {
                [bean sendSerialString:@"e"];
        }
        else {
                [bean sendSerialString:@"f"];
        }
        
        if ([SRCK.stringValue isEqual: @"HIGH"]) {
                [bean sendSerialString:@"g"];
        }
        else {
                [bean sendSerialString:@"h"];
        }
        
        if ([SER_IN.stringValue isEqual: @"1"]) {
                [bean sendSerialString:@"i"];
        }
        else {
                [bean sendSerialString:@"j"];
        }
        
        if ([SHIFT.stringValue isEqual: @"OFF"]) {
                [bean sendSerialString:@"k"];
        }
        else {
                [bean sendSerialString:@"l"];
        }
        
}

- (IBAction) clearAll:(id)sender {
        // set SRCLR low then high
        [bean sendSerialString:@"b"];
        [bean sendSerialString:@"a"];
        
        // set RCK high then low
        [bean sendSerialString:@"e"];
        [bean sendSerialString:@"f"];
}

- (IBAction) sendKeystroke:(id)sender {
        // set G to low (send keystroke)
        [bean sendSerialString:@"d"];
        G.stringValue = @"LOW";
        
        // set G to high (stop sending keystroke)
        [bean sendSerialString:@"c"];
        G.stringValue = @"HIGH";
}

- (IBAction) test8:(id)sender {
        // test all 8 keystrokes on the first shift register
        
        // shift in 8 bits
        for (int key=0;key<8;key++) {
                NSLog(@"Sending: %d",key);
                // send the bit
                [self setBit:key];
                
                // send the keystroke
                [self sendKeystroke:self];
        }
        // send keystroke
        // clear all
        
        
}

- (void) setBit:(int)bit {
        // input: a number between 0 and 47
        
        // clears first
        // then sets a particular bit by shifting in zeros then the bit
        
        // clear
        //[bean sendSerialString:@"baef"];
        [self clearAll:self];
        
        // first, shift a 1
        [self shiftOne:self];
        
        // now shift 48-bit number of zeros
        for (int i=0;i<bit;i++) {
                [self shiftZero:self];
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

-(void)bean:(PTDBean *)bean didUpdateScratchNumber:(NSNumber *)number withValue:(NSData *)data {
        // assume a NULL termiated string
        
        //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithUTF8String:[data bytes]];
        NSString *msg = [NSString stringWithFormat:@"received scratch number:%@ scratch:%@", number, str];
        PTDLog(@"%@", msg);
}

- (IBAction) checkScratch:(id)sender {
                for (int i=1;i<=5;i++) {
                        [bean readScratchBank:i];
                        //NSLog(@"Read scratch %d\n",i);
                }
}

- (void)updateAll {
        static unsigned long counter = 0;
        
        // wait for bean to connect
        if (bean.state == BeanState_ConnectedAndValidated) {
                [bean readAccelerationAxis];
                if (counter % 10 == 0) { // only check once a second
                        [bean readTemperature];
                }
                if (counter == 0) { // check scratch values on first iteration
                                    // also turn on LED if it is set to ON
                        [self checkScratch:self];
                }
                counter++;
        }
}

- (IBAction)disconnect:(id)sender {
        
        [threadLock lock]; // Must invalidate timer in a lock?
        [self.updateTimer invalidate];
        [threadLock unlock];

        [beanManager disconnectBean:bean error:nil];
}

@end
