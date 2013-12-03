//
//  LLViewController.h
//  Overdue2
//
//  Created by Len on 12/2/13.
//  Copyright (c) 2013 LL inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
