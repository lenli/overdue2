//
//  LLEditTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@protocol LLEditTaskViewControllerDelegate <NSObject>
-(void)didUpdateTask;
-(void)updateCompletedSwitch;
@end

@interface LLEditTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) id <LLEditTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) LLTask *taskObject;
@property (strong, nonatomic) IBOutlet UILabel *taskToDoLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskCompletedLabel;
@property (strong, nonatomic) IBOutlet UISwitch *taskCompletedSwitch;

- (IBAction)switchButtonPressed:(UISwitch *)sender;
- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender;

@end