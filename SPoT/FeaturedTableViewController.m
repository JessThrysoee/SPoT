//
//  FeaturedTableViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 20/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "FeaturedTableViewController.h"
#import "TagGroupViewController.h"
#import "FlickrFetcher.h"

@implementation FeaturedTableViewController

- (void)viewDidLoad
{
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refresh];
}


- (void)refresh
{
    [self.refreshControl beginRefreshing];
    
    self.model = nil;
    dispatch_queue_t queue = dispatch_queue_create("feature table refresh", NULL);
    dispatch_async(queue, ^{
        Model *model = [[Model alloc] initWithPhotos];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.model = model;
            [self.refreshControl endRefreshing];
        });
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.tags count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tag = self.model.tags[indexPath.row];
    
    cell.textLabel.text = tag;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [self.model.photosWithTag[tag] count] ];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"ShowTagGroup"])
            {
                if ([segue.destinationViewController isKindOfClass:[TagGroupViewController class]])
                {
                    TagGroupViewController *tagGroup = (TagGroupViewController *)segue.destinationViewController;
                    
                    NSString *tag = cell.textLabel.text;
                    tagGroup.tag = tag;
                    tagGroup.model = self.model;
                }
            }
        }
    }
}


@end
