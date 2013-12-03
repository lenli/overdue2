//
//  LLEditTaskViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLEditTaskViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender;

@end
