//
//  LLHelper.m
//  Overdue2
//
//  Created by Len on 11/29/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLHelper.h"

@implementation LLHelper

#pragma mark - Helper Methods
-(void)updateCompletedSwitch
{
    BOOL isTaskOverdue = [self isDateGreaterThanDate:[NSDate date] and:self.taskObject.date];
    
    if (self.taskObject.isCompleted) {
        self.taskCompletedLabel.text = @"Completed";
        [self.taskCompletedSwitch setOn:YES];
        self.taskCompletedSwitch.thumbTintColor = [UIColor whiteColor];
    } else if (isTaskOverdue) {
        self.taskCompletedSwitch.tintColor = [UIColor redColor];
        self.taskCompletedSwitch.thumbTintColor = [UIColor redColor];
        self.taskCompletedLabel.text = @"Overdue";
        [self.taskCompletedSwitch setOn:NO];
    } else {
        self.taskCompletedSwitch.tintColor = [UIColor yellowColor];
        self.taskCompletedSwitch.thumbTintColor = [UIColor yellowColor];
        self.taskCompletedLabel.text = @"In Progress";
        [self.taskCompletedSwitch setOn:NO];
    }
}

-(BOOL)isDateGreaterThanDate:(NSDate *)isDate and:(NSDate *)greaterThanDate
{
    NSTimeInterval firstDate = [isDate timeIntervalSince1970];
    NSTimeInterval secondDate = [greaterThanDate timeIntervalSince1970];
    
    if (firstDate > secondDate) return YES;
    else return NO;
    
}
@end
