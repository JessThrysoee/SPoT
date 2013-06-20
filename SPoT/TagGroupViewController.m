//
//  TagGroupViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 21/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "TagGroupViewController.h"
#import "FlickrFetcher.h"

@interface TagGroupViewController ()
@end

@implementation TagGroupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.tag;
}


- (void)setModel:(Model *)model
{
    super.model = model;
}


- (NSArray *)photos
{
    return self.model.photosWithTag[self.tag];
}


@end
