//
//  LLTask.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLTask.h"

@implementation LLTask

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.title = data[TASK_TITLE];
            NSLog(@"data title: %@", data[TASK_TITLE]);
            NSLog(@"self title: %@", self.title);
        self.description = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [ data[TASK_COMPLETION] boolValue ];
    }
    NSLog(@"self: %@", self);
    return self;
}

@end
