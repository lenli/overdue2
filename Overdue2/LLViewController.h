//
//  LLViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLAddTaskViewController.h"

@interface LLViewController : UIViewController <LLAddTaskViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskObjects;

- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
