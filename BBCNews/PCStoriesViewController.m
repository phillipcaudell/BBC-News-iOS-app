//
//  PCStoriesViewController.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCStoriesViewController.h"
#import "PCStoryViewController.h"
#import "PCStoryViewCell.h"
#import "NSDate+TimeAgo.h"

@interface PCStoriesViewController ()

@end

@implementation PCStoriesViewController

- (id)initWithTopic:(PCTopic *)topic
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

        self.topic = topic;
        
        self.title = topic.topicTitle;
        self.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"PCTabBarItem-%@", topic.topicId]];
        [self.tableView registerClass:[PCStoryViewCell class] forCellReuseIdentifier:@"Cell"];

        // Show logo if topic is headline
        if ([topic.topicId isEqualToString:@"headlines"]){
            
            UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBar-logo"]];
            logoView.frame = CGRectMake(0, 0, 150, 44);
            self.navigationItem.titleView = logoView;
       
        }
        
        // Add observer to topics to be notified of any changes
        [self.topic addObserver:self forKeyPath:@"stories" options:0 context:nil];
        
        // Pull to refresh
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl beginRefreshing];

    }
    return self;
}

- (void)refreshControlAction:(UIRefreshControl *)sender
{
    [self.topic loadStories];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If we don't have any stories, load some, otherwise don't reload every time the view appears.
    if (!self.topic.stories) {
        [self.topic loadStories];
    }
}

#pragma mark - KVO Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"stories"]) {

        [self.refreshControl endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topic.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PCStoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    PCStory *story = self.topic.stories[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = story.storyTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = [story.storyPublished timeAgo];
    cell.thumbnailView.imageURL = story.thumbnailURL;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCStory *story = self.topic.stories[indexPath.row];
    
    PCStoryViewController *viewController = [[PCStoryViewController alloc] initWithStory:story];
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
