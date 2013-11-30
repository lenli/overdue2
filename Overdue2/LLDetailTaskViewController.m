//
//  LLDetailTaskViewController.m
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import "LLDetailTaskViewController.h"

@interface LLDetailTaskViewController ()

@end

@implementation LLDetailTaskViewController

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
    
    // Title Label
    self.taskTitleLabel.text = self.taskObject.title;
    
    // Detail Label Aligned Top Left
    CGRect labelFrame = CGRectMake(20, 255, 280, 150);
    self.taskDetailLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self updateTaskDetail];
    [self.view addSubview:self.taskDetailLabel];
    
    // Date Label
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *dateAsString = [formatter stringFromDate:self.taskObject.date];
    self.taskDateLabel.text = dateAsString;
    
    // Switch
    self.taskCompletedSwitch.tintColor = [UIColor yellowColor];
    [self updateCompletedSwitch];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[LLEditTaskViewController class]]) {
        LLEditTaskViewController *targetViewController = segue.destinationViewController;
        targetViewController.taskObject = self.taskObject;
        targetViewController.delegate = self;
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchButtonPressed:(UISwitch *)sender {
    self.taskObject.isCompleted = !self.taskObject.isCompleted;
    [self updateCompletedSwitch];
    [self.delegate updateTask];
}

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toEditTaskViewControllerSegue" sender:sender];
}

#pragma mark - LLEditTaskViewControllerDelegate
-(void)didUpdateTask
{
    self.taskTitleLabel.text = self.taskObject.title;
    
    [self updateTaskDetail];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *dateAsString = [formatter stringFromDate:self.taskObject.date];
    self.taskDateLabel.text = dateAsString;
    
    [self updateCompletedSwitch];

    [self.delegate updateTask];
    [self.navigationController popViewControllerAnimated:YES];
}

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
-(void)updateTaskDetail
{
    [self.taskDetailLabel removeFromSuperview];
    CGRect labelFrame = CGRectMake(20, 255, 280, 150);
    self.taskDetailLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self.taskDetailLabel setText:self.taskObject.description];
    [self.taskDetailLabel setTextColor:[UIColor darkGrayColor]];
    [self.taskDetailLabel setFont: [UIFont fontWithName:@"Avenir" size:16.0]];
    [self.taskDetailLabel setNumberOfLines:0];
    [self.taskDetailLabel sizeToFit];
    [self.view addSubview:self.taskDetailLabel];
}
@end
