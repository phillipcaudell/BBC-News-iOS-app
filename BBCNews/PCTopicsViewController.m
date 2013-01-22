//
//  PCTopicsViewController.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCTopicsViewController.h"

@interface PCTopicsViewController ()

@end

@implementation PCTopicsViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.tabBarController = [[UITabBarController alloc] init];
        self.newsController = [[PCNewsController alloc] init];
        [self.newsController addObserver:self forKeyPath:@"topics" options:0 context:nil];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tabBarController.view];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tabBarController.view.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark KVO Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"topics"]) {
        
        self.tabBarController.viewControllers = [self viewControllersForTopics:self.newsController.topics];
        
    }
}

- (NSArray *)viewControllersForTopics:(NSArray *)topics
{
    NSMutableArray *storiesViewControllers = [NSMutableArray array];
    
    for (PCTopic *topic in topics){
        
        PCStoriesViewController *viewController = [[PCStoriesViewController alloc] initWithTopic:topic];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [storiesViewControllers addObject:navigationController];
        
    }
    
    return storiesViewControllers;
}

@end
