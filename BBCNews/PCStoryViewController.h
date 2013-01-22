//
//  PCStoryViewController.h
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCStory.h"

@interface PCStoryViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) PCStory *story;
@property (nonatomic, strong) UIWebView *webView;

- (id)initWithStory:(PCStory *)story;
- (id)initWithURL:(NSURL *)url;

@end
