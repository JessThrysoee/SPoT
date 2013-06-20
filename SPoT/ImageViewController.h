//
//  ImageViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 21/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSURL *imageURL;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)setSplitViewBarButtonItemTitle:(NSString *)title;

@end
