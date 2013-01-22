//
//  PCStoryViewCell.m
//  BBCNews
//
//  Created by Phillip Caudell on 21/01/2013.
//  Copyright (c) 2013 3SIDEDCUBE. All rights reserved.
//

#import "PCStoryViewCell.h"

@implementation PCStoryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.thumbnailView = [[PCImageView alloc] init];
        self.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnailView.clipsToBounds = YES;
        [self.contentView addSubview:self.thumbnailView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thumbnailView.frame = CGRectMake(0, 0, 88, 88);
    
    self.textLabel.frame = CGRectMake(98, self.textLabel.frame.origin.y, self.contentView.frame.size.width - 98, self.textLabel.frame.size.height);
    
    self.detailTextLabel.frame = CGRectMake(98, self.detailTextLabel.frame.origin.y, self.contentView.frame.size.width - 98, self.detailTextLabel.frame.size.height);

}

@end
