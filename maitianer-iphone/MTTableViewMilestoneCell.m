//
//  MTTableViewMilestoneCell.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-12-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTTableViewMilestoneCell.h"

@implementation MTTableViewMilestoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 5, 60, 60);
    self.detailTextLabel.frame = CGRectMake(80, 5, 230, 48);
    self.detailTextLabel.textColor = RGBCOLOR(175, 185, 168);
    self.textLabel.frame = CGRectMake(80, 48, 230, 12);
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.textAlignment = UITextAlignmentRight;
    self.textLabel.textColor = [UIColor grayColor];
}

@end
