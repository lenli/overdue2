//
//  LLHelper.h
//  Overdue2
//
//  Created by Len on 11/29/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLHelper : NSObject
-(void)updateCompletedSwitch;
-(BOOL)isDateGreaterThanDate:(NSDate *)isDate and:(NSDate *)greaterThanDate;
@end
