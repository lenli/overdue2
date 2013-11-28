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
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TASKLIST_OBJECT_KEY];
    
    NSArray *taskList = [[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY];
    for (NSDictionary *dictionary in taskList) {
        LLTask *taskObject = [self taskObjectFromDictionary:dictionary];
        [self.taskObjects addObject:taskObject];
    }
    NSLog(@"taskObjects: %@",self.taskObjects);

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
    } else if ([segue.destinationViewController isKindOfClass:[LLDetailTaskViewController class]]) {
        LLDetailTaskViewController *targetViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        
        LLTask *selectedTask = self.taskObjects[path.row];
        targetViewController.taskObject = selectedTask;
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
    
    // Cell Color
    BOOL isTaskOverdue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    if (task.isCompleted) cell.backgroundColor = [UIColor greenColor];
    else if (isTaskOverdue) cell.backgroundColor = [UIColor redColor];
    else cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLTask *task = self.taskObjects[indexPath.row];
    [self updateCompletionStatusOfTask:task forIndexPath:indexPath];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *newTaskList = [[NSMutableArray alloc] init];
        for (LLTask *taskObject in self.taskObjects) {
            [newTaskList addObject:[self taskObjectAsAPropertyList:taskObject]];
            
        }
        /*
        NSMutableArray *taskList = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY] mutableCopy];
        if (!taskList) taskList = [[NSMutableArray alloc] init];
        
        [taskList removeObjectAtIndex:indexPath.row];*/
        
        [[NSUserDefaults standardUserDefaults] setObject:newTaskList forKey:TASKLIST_OBJECT_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

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

-(BOOL)isDateGreaterThanDate:(NSDate *)isDate and:(NSDate *)greaterThanDate
{
    NSTimeInterval firstDate = [isDate timeIntervalSince1970];
    NSTimeInterval secondDate = [greaterThanDate timeIntervalSince1970];
    
    if (firstDate > secondDate) return YES;
    else return NO;
    
}

-(void)updateCompletionStatusOfTask:(LLTask *)task forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *taskList = [[[NSUserDefaults standardUserDefaults] objectForKey:TASKLIST_OBJECT_KEY] mutableCopy];
    if (!taskList) taskList = [[NSMutableArray alloc] init];
    
    [taskList removeObjectAtIndex:indexPath.row];
    
    task.isCompleted = !task.isCompleted;   // Toggle BOOL
    [taskList insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}
@end
