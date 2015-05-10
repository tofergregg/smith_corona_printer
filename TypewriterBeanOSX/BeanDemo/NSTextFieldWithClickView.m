//
//  NSTextFieldWithClickView.m
//  BeanDemo
//
//  Created by Chris Gregg on 6/14/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//
//  The LightBlue Bean can be found here:
//  http://punchthrough.com/bean/
//
//  The libBean SDK can be found here:
//  https://github.com/PunchThrough/Bean-iOS-OSX-SDK

#import "NSTextFieldWithClickView.h"

@implementation NSTextFieldWithClickView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
        [self sendAction:[self action] to:[self target]];
}

@end
