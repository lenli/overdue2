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
    self.taskTitleLabel.text = self.taskObject.title;
    self.taskDetailLabel.text = self.taskObject.description;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *dateAsString = [formatter stringFromDate:self.taskObject.date];
    self.taskDateLabel.text = dateAsString;
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
    self.taskDetailLabel.text = self.taskObject.description;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSString *dateAsString = [formatter stringFromDate:self.taskObject.date];
    self.taskDateLabel.text = dateAsString;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate updateTask];
    [self updateCompletedSwitch];
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
@end
