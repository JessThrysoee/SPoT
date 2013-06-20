//
//  SPoTTableViewController.h
//  SPoT
//
//  Created by Jess Thrysoee on 20/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model.h"

@interface SPoTTableViewController : UITableViewController

@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) NSArray *photos;

@end
