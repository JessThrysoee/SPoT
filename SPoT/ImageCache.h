//
//  ImageCache.h
//  SPoT
//
//  Created by Jess Thrysoee on 25/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

- (NSData *)getImageData:(NSURL *)name;
- (BOOL)addImageData:(NSData *)imageData withName:(NSURL *)name;

@end
