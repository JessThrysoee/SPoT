//
//  model.h
//  SPoT
//
//  Created by Jess Thrysoee on 20/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

- (id)initWithPhotos;

@property (nonatomic, strong) NSArray *tags;  // NSString
@property (nonatomic, strong) NSDictionary *photosWithTag;

- (void)addRecentPhotos:(NSDictionary *)photo;

@end
