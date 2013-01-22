//
//  PCNewsController.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCNewsController.h"

@implementation PCNewsController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.requestController = [[PCRequestController alloc] initWithBaseAddress:@"http://api.bbcnews.appengine.co.uk"];
        [self loadTopics];
        
    }
    return self;
}

- (void)loadTopics
{
    [self.requestController get:@"topics" params:nil completionHandler:^(PCRequestResponse *response, NSError *error) {
                
        NSMutableArray *topics = [NSMutableArray array];
        
        for (NSDictionary *topicDictionary in response.dictionaryFromJSON[@"topics"]){
                    
            PCTopic *topic = [[PCTopic alloc] initWithDictionary:topicDictionary];
            topic.newsController = self;
            [topics addObject:topic];
            
        }
        
        self.topics = topics;
        
    }];
}

@end
