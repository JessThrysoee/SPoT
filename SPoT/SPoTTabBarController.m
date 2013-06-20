//
//  SPoTTabBarController.m
//  SPoT
//
//  Created by Jess Thrysoee on 21/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SPoTTabBarController.h"
#import "RecentsViewController.h"

@interface SPoTTabBarController () <UISplitViewControllerDelegate, UITabBarControllerDelegate>
@end

@implementation SPoTTabBarController

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
    self.delegate = self;
}


- (void)viewDidLoad
{
    [self setSelectedIndex:0];
    [self setStartupImage];
}


- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [self setSplitViewDetailButton:barButtonItem];
    self.barButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self setSplitViewDetailButton:nil];
    self.barButtonItem = nil;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self setSplitViewDetailButtonTitle];
    
    if ([viewController isKindOfClass:[RecentsViewController class]])
    {
        RecentsViewController *recents = (RecentsViewController *)viewController;
        [recents update];
    }
}


- (void)setSplitViewDetailButtonTitle
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItemTitle:)])
    {
        [detailViewController performSelector:@selector(setSplitViewBarButtonItemTitle:) withObject:self.selectedViewController.title];
    }
}


- (void)setSplitViewDetailButton:(UIBarButtonItem *)barButtonItem
{
    barButtonItem.title = self.selectedViewController.title;
    
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
    {
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
    }
}


- (void)setStartupImage
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if ([detailViewController respondsToSelector:@selector(setImageURL:)])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stanford_bw" ofType:@"jpg"];
        NSURL *fileURL  = [NSURL fileURLWithPath:filePath];
        
        [detailViewController performSelector:@selector(setImageURL:) withObject:fileURL];
    }
}


@end
