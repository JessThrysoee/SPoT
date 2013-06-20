//
//  RecentsViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 21/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "RecentsViewController.h"
#import "FlickrFetcher.h"

@interface RecentsViewController ()
@end

@implementation RecentsViewController
@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}


- (void)update
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.photos = [defaults objectForKey:@"recents"];
}


@end
