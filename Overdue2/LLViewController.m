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
    
    // Load Default Task
    NSDictionary *defaultTask = @{TASK_TITLE: @"README task",
                                  TASK_DATE: [NSDate date],
                           TASK_DESCRIPTION: @"Welcome to Overdue, a lightweight task list app where you can add new tasks, reorder tasks, and delete tasks. You can also toggle tasks between “complete” (green) to “in progress” (yellow) or “overdue” (red).\n\nMore advanced features soon.\n@lenli",
                            TASK_COMPLETION: @NO
                                  };
    NSArray *defaultArray = @[defaultTask];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 defaultArray, TASKLIST_OBJECT_KEY, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    
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
    } else if ([segue.destinationViewController isKindOfClass:[LLDetailTaskViewController class]]) {
        LLDetailTaskViewController *targetViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        
        LLTask *selectedTask = self.taskObjects[path.row];
        targetViewController.taskObject = selectedTask;
        targetViewController.delegate = self;
    }
}

- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
}

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableView.editing == NO) {
        [self.tableView setEditing: YES animated: YES];
        self.navigationItem.leftBarButtonItem.title = @"Done";
    } else {
        [self.tableView setEditing: NO animated: YES];
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    }
    
}

#pragma mark -- LLAddTaskViewControllerDelegate
- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(LLTask *)task
{
    [self.taskObjects addObject:task];
    [self saveTasks];

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
    
    // Title
    cell.textLabel.text = task.title;
    [cell.textLabel setFont: [UIFont fontWithName:@"Avenir" size:16.0]];
    
    // Date
    [cell.detailTextLabel setFont: [UIFont fontWithName:@"Avenir" size:12.0]];
    if (task.isCompleted) {
        cell.detailTextLabel.text = @"Completed";
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"'Due' yyyy-MM-dd 'at' HH:mm"];
        NSString *stringFromDate = [formatter stringFromDate:task.date];
        cell.detailTextLabel.text = stringFromDate;
    }
    
    // Cell ImageView
    BOOL isTaskOverdue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
    
    cell.imageView.layer.cornerRadius = 7.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.imageView.layer.borderWidth = 3.0;
    
    if (task.isCompleted) cell.imageView.backgroundColor = [UIColor greenColor];
    else if (isTaskOverdue) cell.imageView.backgroundColor = [UIColor redColor];
    else cell.imageView.backgroundColor = [UIColor yellowColor];
    
    cell.imageView.image = (task.isCompleted) ? [UIImage imageNamed:@"checked_checkbox.png"] : [UIImage imageNamed:@"unchecked_checkbox.png"];
  
    // Cell AccessoryView
    UIImage *accImage = [UIImage imageNamed:@"find_search.png"];
    UIButton *accButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, accImage.size.width, accImage.size.height);
    accButton.frame = frame;
    
    [accButton setBackgroundImage:accImage forState:UIControlStateNormal];
    [accButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    accButton.backgroundColor = [UIColor clearColor];
    cell.accessoryView = accButton;
    
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
        [self saveTasks];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary *taskObjectToMove = self.taskObjects[sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObjectToMove atIndex:destinationIndexPath.row];
    [self saveTasks];
}

#pragma mark -- LLDetailTaskViewControllerDelegate

-(void)updateTask
{
    [self saveTasks];
    [self.tableView reloadData];
}

#pragma mark -- Helper Methods
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

-(void)saveTasks
{
    NSMutableArray *taskList = [[NSMutableArray alloc] init];
    // for (int x = 0; x < [self.taskObjects count]; x ++) {
    for (LLTask *taskObject in self.taskObjects) {
        [taskList addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:taskList forKey:TASKLIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

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
