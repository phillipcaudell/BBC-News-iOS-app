//
//  PCTopic.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCTopic.h"

@implementation PCTopic

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.topicId = dictionary[@"id"];
        self.topicTitle = dictionary[@"title"];
        
    }
    return self;
}

- (void)loadStories
{
    [self.newsController.requestController get:[NSString stringWithFormat:@"stories/%@", self.topicId] params:nil completionHandler:^(PCRequestResponse *response, NSError *error) {
        
        NSMutableArray *stories = [NSMutableArray array];
        
        for (NSDictionary *storyDictionary in response.dictionaryFromJSON[@"stories"]){
            
            PCStory *story = [[PCStory alloc] initWithDictionary:storyDictionary];
            [stories addObject:story];
            
        }
        
        self.stories = stories;
        
    }];
}

@end
