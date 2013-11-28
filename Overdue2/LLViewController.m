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
    
    // Load TaskList from NSUserDefaults
    NSArray *taskList = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    for (NSDictionary *dictionary in taskList) {
        LLTask *taskObject = [self taskObjectFromDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
    }

    // Set up Table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskObjects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure Cell
    LLTask *task = self.taskObjects[indexPath.row];
    cell.textLabel.text = task.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    cell.detailTextLabel.text = stringFromDate;
    
    return cell;
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

-(LLTask *)taskObjectFromDictionary:(NSDictionary *)dictionary
{
    LLTask *taskObject = [[LLTask alloc] initWithData:dictionary];
    return taskObject;
}

@end
