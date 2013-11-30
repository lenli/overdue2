//
//  LLAddTaskViewController.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLAddTaskViewController.h"

@interface LLAddTaskViewController ()

@end

@implementation LLAddTaskViewController

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
    self.nameTextField.delegate = self;
    self.detailTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    LLTask *newTask = [self getTaskObject];
    [self.delegate didAddTask:newTask];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}

#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:self];
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

#pragma mark - Helper Methods
- (LLTask *)getTaskObject
{
    LLTask *newTask = [[LLTask alloc] init];
    newTask.title = self.nameTextField.text;
    newTask.description = self.detailTextView.text;
    newTask.date = self.datePicker.date;
    newTask.isCompleted = NO;
    
    return newTask;
}
@end
