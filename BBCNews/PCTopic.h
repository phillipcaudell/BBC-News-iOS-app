//
//  PCTopic.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PCNewsController.h"
@class PCNewsController;

@interface PCTopic : NSObject

@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicTitle;

@property (nonatomic, weak) PCNewsController *newsController;
@property (nonatomic, strong) NSArray *stories;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadStories;

@end
