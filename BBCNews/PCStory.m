//
//  PCStory.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCStory.h"

@implementation PCStory

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.storyTitle = dictionary[@"title"];
        self.storyDescription = dictionary[@"description"];
        self.storyPublished = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"published"] integerValue]];
        self.fullStoryURL = [NSURL URLWithString:dictionary[@"link"]];
        self.thumbnailURL = [NSURL URLWithString:dictionary[@"thumbnail"]];
        
    }
    return self;
}

@end
