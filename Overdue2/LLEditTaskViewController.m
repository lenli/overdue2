//
//  LLEditTaskViewController.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLEditTaskViewController.h"

@interface LLEditTaskViewController ()

@end

@implementation LLEditTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.titleTextField.text = self.taskObject.title;
    self.detailTextView.text = self.taskObject.description;
    self.datePicker.date = self.taskObject.date;
    [self updateCompletedSwitch];
    
    self.titleTextField.delegate = self;
    self.detailTextView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchButtonPressed:(UISwitch *)sender {
    self.taskObject.isCompleted = !self.taskObject.isCompleted;
    [self updateCompletedSwitch];
}

- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender {
    [self updateTask];
    [self.delegate didUpdateTask];
}

-(void)updateTask
{
    self.taskObject.title = self.titleTextField.text;
    self.taskObject.description = self.detailTextView.text;
    self.taskObject.date = self.datePicker.date;
}

#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.detailTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

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

