//
//  model.m
//  SPoT
//
//  Created by Jess Thrysoee on 20/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "Model.h"
#import "FlickrFetcher.h"
#import "NetworkActivity.h"

@interface Model ()
@property (nonatomic, strong) NSArray *stanfordPhotos;
@end

@implementation Model

- (id)init
{
    return [super init];
}

- (id)initWithPhotos
{
    self = [self init];
    if (self) {
        _stanfordPhotos = [FlickrFetcher stanfordPhotos];
    }
    return self;
}

- (NSArray *)stanfordPhotos
{
    if (!_stanfordPhotos)
    {
        _stanfordPhotos = [FlickrFetcher stanfordPhotos];
    }
    
    return _stanfordPhotos;
}


#define RECENTS_KEY        @"recents"
#define MAX_RECENTS_PHOTOS 10

- (void)addRecentPhotos:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPhotos = [[defaults objectForKey:RECENTS_KEY] mutableCopy];
    
    if (!recentPhotos)
    {
        recentPhotos = [[NSMutableArray alloc] init];
    }
    
    NSArray *tmp = [recentPhotos copy];
    
    for (NSDictionary *savedPhoto in tmp)
    {
        if (savedPhoto[FLICKR_PHOTO_ID] == photo[FLICKR_PHOTO_ID])
        {
            [recentPhotos removeObject:savedPhoto];
        }
    }
    
    [recentPhotos insertObject:photo atIndex:0];
    
    if ([recentPhotos count] > MAX_RECENTS_PHOTOS)
    {
        [recentPhotos removeObjectsInRange:NSMakeRange(MAX_RECENTS_PHOTOS, [recentPhotos count] - MAX_RECENTS_PHOTOS)];
    }
    
    [defaults setObject:recentPhotos forKey:RECENTS_KEY];
    [defaults synchronize];
}


- (NSArray *)tags
{
    if (!_tags)
    {
        NSArray *keys = [self.photosWithTag allKeys];
        _tags = [keys sortedArrayUsingSelector:@selector(compare:)];
    }
    
    return _tags;
}


- (NSDictionary *)photosWithTag
{
    if (!_photosWithTag)
    {
        NSArray *exceptions = @[@"cs193pspot", @"portrait", @"landscape"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *photo in self.stanfordPhotos)
        {
            for (NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString : @" "])
            {
                if ([exceptions containsObject:[tag lowercaseString]])
                {
                    continue;
                }
                
                NSString *capTag = [tag capitalizedString];
                NSArray *tagged = [dict objectForKey:capTag];
                
                if (tagged)
                {
                    [dict setObject:[tagged arrayByAddingObject:photo] forKey:capTag];
                }
                else
                {
                    [dict setObject:@[photo] forKey:capTag];
                }
            }
        }
        
        // sort sub arrays by title
        for (NSString *tag in [dict allKeys])
        {
            NSArray *list = [dict objectForKey:tag];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES];
            [dict setObject:[list sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]] forKey:tag];
        }
        
        _photosWithTag = [dict copy];
    }
    
    return _photosWithTag;
}


@end
