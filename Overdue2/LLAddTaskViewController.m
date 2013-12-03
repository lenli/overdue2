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
