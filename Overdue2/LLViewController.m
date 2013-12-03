//
//  LLViewController.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLViewController.h"

@interface LLViewController ()

@end

@implementation LLViewController

- (NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[LLAddTaskViewController class]]) {
        LLAddTaskViewController *targetViewController = segue.destinationViewController;
        targetViewController.delegate = self;
    }
}

- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender {
}

#pragma mark -- LLAddTaskViewControllerDelegate
- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(LLTask *)task
{
    [self.taskObjects addObject:task];
    
    NSMutableArray *savedTasksArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASKLIST_OBJECT_KEY] mutableCopy];
    if (!savedTasksArray) savedTasksArray = [[NSMutableArray alloc] init];
    
    NSDictionary *taskObjectAsDictionary = [self taskObjectAsAPropertyList:task];
    [savedTasksArray addObject:taskObjectAsDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:savedTasksArray forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- Helper Methods

-(NSDictionary *)taskObjectAsAPropertyList:(LLTask *)taskObject
{
    NSDictionary *taskObjectAsDictionary = @{TASK_TITLE: taskObject.title,
                                             TASK_DESCRIPTION: taskObject.description,
                                             TASK_DATE: taskObject.date,
                                             TASK_COMPLETION: taskObject.isCompleted ? @"YES" : @"NO"
                                             };
    return taskObjectAsDictionary;
}

@end
