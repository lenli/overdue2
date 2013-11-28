//
//  LLDetailTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@interface LLDetailTaskViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailLabel;
@property (strong, nonatomic) LLTask *taskObject;

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
