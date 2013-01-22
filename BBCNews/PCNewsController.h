//
//  PCNewsController.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCRequestKit.h"
#import "PCTopic.h"
#import "PCStory.h"

@interface PCNewsController : NSObject

@property (nonatomic, strong) PCRequestController *requestController;
@property (nonatomic, strong) NSArray *topics;

@end
