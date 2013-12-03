//
//  LLAddTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAddTaskViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)addTaskButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButtonPressed;

@end
