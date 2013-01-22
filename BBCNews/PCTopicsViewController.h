//
//  PCTopicsViewController.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCNewsController.h"
#import "PCStoriesViewController.h"

@interface PCTopicsViewController : UIViewController

@property (nonatomic, strong) PCNewsController *newsController;
@property (nonatomic, strong) UITabBarController *tabBarController;

@end
