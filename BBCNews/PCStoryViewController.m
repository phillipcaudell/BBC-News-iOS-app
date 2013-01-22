//
//  PCStoryViewController.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCStoryViewController.h"

@interface PCStoryViewController ()

@end

@implementation PCStoryViewController

- (id)initWithStory:(PCStory *)story
{
    self = [super init];
    if (self) {
                
        self.story = story;
        
        self.title = story.storyTitle;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
        
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.webView.backgroundColor = [UIColor whiteColor];
        
        [self loadURL:story.fullStoryURL];
                
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        
        [self loadURL:url];

    }
    return self;
}

- (void)loadURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    // Remove shadow on webview
    for(UIView *viewShadow in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if([viewShadow isKindOfClass:[UIImageView class]]){
            viewShadow.hidden = YES;
        }
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)shareAction:(UIBarButtonItem *)sender
{
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.story.storyTitle, self.story.fullStoryURL] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - WebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Hide the header and the footer using Javascript BECAUSE WE CAN
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('blq-mast-bar').style.display = 'none'; self.document.getElementsByClassName('site-brand')[0].style.display = 'none'; document.getElementById('blq-foot').style.display = 'none'; self.document.getElementsByClassName('share-this')[0].style.display = 'none'; document.getElementById('story-onward-journey').style.display = 'none'; self.document.getElementsByClassName('site-foot')[0].style.display = 'none';"];
}

@end
