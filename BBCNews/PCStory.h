//
//  PCStory.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCStory : NSObject

@property (nonatomic, strong) NSString *storyTitle;
@property (nonatomic, strong) NSString *storyDescription;
@property (nonatomic, strong) NSDate *storyPublished;
@property (nonatomic, strong) NSURL *fullStoryURL;
@property (nonatomic, strong) NSURL *thumbnailURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
