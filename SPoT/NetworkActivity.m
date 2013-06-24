//
//  NetworkActivity.m
//  SPoT
//
//  Created by Jess Thrysoee on 24/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "NetworkActivity.h"

@implementation NetworkActivity

+ (void)indicatorVisible:(BOOL)setVisible
{
    static NSInteger refCount = 0;
    
    @synchronized(self)
    {
        if (setVisible)
        {
            refCount++;
        }
        else
        {
            refCount--;
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(refCount > 0)];
    }
}


@end
