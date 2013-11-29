//
//  LLAddTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTask.h"

@protocol LLAddTaskViewControllerDelegate
-(void)didCancel;
-(void)didAddTask:(LLTask *)task;
@end

@interface LLAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) id <LLAddTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;


@end
