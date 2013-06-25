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


- (void)evict
{
    NSFileManager *fileMan = [[NSFileManager alloc] init];
    NSArray *contents = [fileMan contentsOfDirectoryAtPath:[self.cacheDir path] error:nil];
    
    if (contents)
    {
        for (NSString *path in contents)
        {
            NSURL *fileURL = [self.cacheDir URLByAppendingPathComponent:path];
            
            NSDictionary *attrs = [fileURL resourceValuesForKeys:@[NSURLTotalFileAllocatedSizeKey, NSURLContentAccessDateKey] error:nil];
        }
        
        // TODO NSArray of dicts, sort them by access, iterate through until cache limit is reached and then delete the rest.
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
    BOOL res = [imageData writeToFile:[self nameToFilePath:name] atomically:NO];
    
    [self evict];
    return res;
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
