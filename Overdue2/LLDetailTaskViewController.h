//
//  LLDetailTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"
#import "LLEditTaskViewController.h"

@protocol LLDetailTaskViewControllerDelegate <NSObject>
-(void)updateTask;
@end

@interface LLDetailTaskViewController : UIViewController <LLEditTaskViewControllerDelegate>
@property (weak, nonatomic) id <LLDetailTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailLabel;
@property (strong, nonatomic) LLTask *taskObject;
@property (strong, nonatomic) IBOutlet UILabel *taskCompletedLabel;
@property (strong, nonatomic) IBOutlet UISwitch *taskCompletedSwitch;

- (IBAction)switchButtonPressed:(UISwitch *)sender;
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
