//
//  PCStoriesViewController.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCTopic.h"

@interface PCStoriesViewController : UITableViewController

@property (nonatomic, strong) PCTopic *topic;

- (id)initWithTopic:(PCTopic *)topic;

@end
