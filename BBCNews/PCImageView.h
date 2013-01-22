//
//  PPImageView.h
//  PowerPress
//
//  Created by Phillip Caudell on 29/10/2012.
//  Copyright (c) 2012 3SIDEDCUBE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCImageView : UIImageView

@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, retain) NSURL *imageURL;

@end

@interface PCImageViewCacheStore : NSObject

@property (nonatomic, retain) NSDictionary *cache;

+ (PCImageViewCacheStore *)sharedController;

@end