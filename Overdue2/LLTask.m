//
//  LLTask.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLTask.h"

@implementation LLTask

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.title = data[TASK_TITLE];
        self.description = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.isCompleted = [ data[TASK_COMPLETION] boolValue ];
        NSLog(@"data title: %@", data[TASK_TITLE]);
        NSLog(@"data description: %@", data[TASK_DESCRIPTION]);
        NSLog(@"data date: %@", data[TASK_DATE]);
        NSLog(@"data isCompleted: %@", data[TASK_COMPLETION]);
    }
    NSLog(@"self title: %@", self.title);
    NSLog(@"self description: %@", self.description);
    NSLog(@"self date: %@", self.date);
    NSLog(@"self isCompleted: %d", self.isCompleted);
    NSLog(@"self: %@", self);
    return self;
}

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

@end
