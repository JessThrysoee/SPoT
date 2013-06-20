//
//  SPoTTableViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 20/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SPoTTableViewController.h"
#import "FlickrFetcher.h"


@implementation SPoTTableViewController
@synthesize model = _model;

- (Model *)model
{
    if (!_model)
    {
        _model = [[Model alloc] init];
    }

    return _model;
}


- (void)setModel:(Model *)model
{
    _model = model;
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [self.photos[indexPath.row][FLICKR_PHOTO_TITLE] description];
    cell.detailTextLabel.text = [[self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        if (indexPath)
        {
            NSDictionary *photo = self.photos[indexPath.row];

            if ([segue.identifier isEqualToString:@"Show Image"] || [segue.identifier isEqualToString:@"Show Recent Image"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    [segue.destinationViewController performSelector:@selector(setTitle:) withObject:photo[FLICKR_PHOTO_TITLE]];

                    //NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatOriginal];
                    NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                }
            }

            if ([segue.identifier isEqualToString:@"Show Image"])
            {
                [self.model addRecentPhotos:photo];
            }
        }
    }
}


@end
