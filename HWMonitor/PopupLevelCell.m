//
//  PopupLevelCell.m
//  HWMonitor
//
//  Created by Kozlek on 02/03/14.
//  Copyright (c) 2014 kozlek. All rights reserved.
//

/*
 *  Copyright (c) 2013 Natan Zalkin <natan.zalkin@me.com>. All rights reserved.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 *  02111-1307, USA.
 *
 */

#import "PopupLevelCell.h"
#import "HWMSmcFanController.h"
#import "HWMSmcFanControlLevel.h"

#define ROUND50(x) (((int)x / 50) * 50)
#define CLIP(x) (x) < 0 ? 0 : (x) > 100 ? 100 : (x)

@implementation PopupLevelCell

-(id)init
{
    self = [super init];

    if (self) {
        [self initialize];
    }

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self initialize];
    }

    return self;
}

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];

    if (self) {
        [self initialize];
    }

    return self;
}

-(void)initialize
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSFont *digitalFont = [NSFont fontWithName:@"Let's go Digital Regular" size:20];
        [_inputTextField setFont:digitalFont];
        [_outputTextField setFont:digitalFont];
    }];
}

-(HWMSmcFanControlLevel *)level
{
    return self.objectValue;
}

- (void)sliderHasMoved:(id)sender
{
    NSTextField *textField = nil;
    NSUInteger value = 0;

    if (sender == self.inputSlider) {
        textField = self.inputTextField;
        value = [sender integerValue];
        value = value < self.level.minInput.integerValue ? self.level.minInput.integerValue : value > self.level.maxInput.integerValue ? self.level.maxInput.integerValue : value;
    }
    else if (sender == self.outputSlider) {
        textField = self.outputTextField;
        value = [sender integerValue];
        value = value < self.level.minOutput.integerValue ? self.level.minOutput.integerValue : value > self.level.maxOutput.integerValue ? self.level.maxOutput.integerValue : value;
        value = ROUND50(value);
    }

    [textField setIntegerValue:value];
    [sender setIntegerValue:value];

    SEL sel = @selector(sliderHasBeenReleased:);

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:sel object:sender];

    [self performSelector:sel withObject:sender afterDelay:0.0];
}

- (void)sliderHasBeenReleased:(id)sender
{
    if (sender == self.inputSlider) {
        [self.level setInput:[NSNumber numberWithInteger:[sender integerValue]]];
    }
    else if (sender == self.outputSlider) {
        [self.level setOutput:[NSNumber numberWithInteger:ROUND50([sender integerValue])]];
    }
}

-(IBAction)insertLevel:(id)sender
{
    [self.level insertNextLevel];
}

-(IBAction)removeLevel:(id)sender
{
    [self.level removeThisLevel];
}

@end
