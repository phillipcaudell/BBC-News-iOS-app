//
//  PPImageView.m
//  PowerPress
//
//  Created by Phillip Caudell on 29/10/2012.
//  Copyright (c) 2012 3SIDEDCUBE. All rights reserved.
//

#import "PCImageView.h"

@implementation PCImageView

- (id)init
{
    self = [super init];
    if (self) {
        
        

    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
    self.image = nil;
    
    NSDictionary *cache = [[PCImageViewCacheStore sharedController] cache];
    NSData *cacheData = [cache objectForKey:[imageURL absoluteString]];
    
    if (cacheData) {
        
        self.image = [UIImage imageWithData:cacheData];
        
    } else {
            
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    
            if ([((NSHTTPURLResponse *)response) statusCode] == 200) {
                self.image = [UIImage imageWithData:data];
                [[[PCImageViewCacheStore sharedController] cache] setValue:data forKey:[imageURL absoluteString]];
            }
        }];
    }
}

@end

@implementation PCImageViewCacheStore

static PCImageViewCacheStore *sharedController = nil;

+ (PCImageViewCacheStore *)sharedController
{
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [[self alloc] init];
        }
    }
    return sharedController;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.cache = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

@end