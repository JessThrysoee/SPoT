//
//  ImageCache.m
//  SPoT
//
//  Created by Jess Thrysoee on 25/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache ()
@property (nonatomic, strong) NSURL *cacheDir;
@end

@implementation ImageCache


- (NSURL *)cacheDir
{
    if (!_cacheDir)
    {
        NSFileManager *fileMan = [[NSFileManager alloc] init];
        NSURL *topDir = [fileMan URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask][0];
        _cacheDir = [topDir URLByAppendingPathComponent:@"imageCache"];
        [fileMan createDirectoryAtURL:_cacheDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return _cacheDir;
}


#define CACHE_SIZE 3000000   // 3MB cache

- (void)makeSpaceForBytes:(NSUInteger)bytes
{
    NSFileManager *fileMan = [[NSFileManager alloc] init];
    NSArray *filesInDir = [fileMan contentsOfDirectoryAtPath:[self.cacheDir path] error:nil];
    
    if (filesInDir && [filesInDir count])
    {
        // get file attrs
        NSMutableArray *fileAttrs = [[NSMutableArray alloc] init];
        
        for (NSString *file in filesInDir)
        {
            NSURL *fileURL = [self.cacheDir URLByAppendingPathComponent:file];
            NSDictionary *attrs = [fileURL resourceValuesForKeys:@[NSURLFileSizeKey, NSURLContentAccessDateKey, NSURLPathKey] error:nil];
            
            if (attrs)
            {
                [fileAttrs addObject:attrs];
            }
        }
        
        // sort desc by atime
        NSSortDescriptor *modifiedDescriptor = [[NSSortDescriptor alloc] initWithKey:NSURLContentAccessDateKey ascending:NO];
        NSArray *sortedArray = [fileAttrs sortedArrayUsingDescriptors:@[modifiedDescriptor]];
        
        // make room for <bytes>
        long totalSize = bytes;
        
        for (NSDictionary *attrs in sortedArray)
        {
            long curSize = [attrs[NSURLFileSizeKey] longValue];
            
            if (totalSize + curSize > CACHE_SIZE)
            {
                [fileMan removeItemAtPath:attrs[NSURLPathKey] error:nil];
            }
            
            totalSize += curSize;
        }
    }
}


- (NSString *)nameToFilePath:(NSURL *)name
{
    NSCharacterSet *illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/:"];
    NSString *encoded = [[[name lastPathComponent] componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
    
    return [[self.cacheDir URLByAppendingPathComponent:encoded] path];
}


- (BOOL)addImageData:(NSData *)imageData withName:(NSURL *)name
{
    if (imageData.length > CACHE_SIZE)
    {
        return NO;
    }
    
    [self makeSpaceForBytes:imageData.length];
    return [imageData writeToFile:[self nameToFilePath:name] atomically:NO];
}


- (NSData *)getImageData:(NSURL *)name
{
    if ([[[NSFileManager alloc] init] isReadableFileAtPath:[self nameToFilePath:name]])
    {
        return [NSData dataWithContentsOfFile:[self nameToFilePath:name]];
    }
    
    return nil;
}


@end
