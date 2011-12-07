//
//  MTTableViewPhotoCell.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-28.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTTableViewPhotoCell.h"

@implementation MTTableViewPhotoCell
@synthesize addMilestoneButton = _addMilestoneButton;
@synthesize editPhotoButton = _editPhotoButton;
@synthesize removePhotoButton = _removePhotoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)dealloc {
    [_addMilestoneButton release];
    [_editPhotoButton release];
    [_removePhotoButton release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height - 10);
    [self.imageView addSubview:self.detailTextLabel];
    self.detailTextLabel.frame = CGRectMake(0, self.imageView.frame.size.height - 20, self.imageView.frame.size.width, 20);
    self.detailTextLabel.backgroundColor = [UIColor blackColor];
    self.detailTextLabel.alpha = 0.7;
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textAlignment = UITextAlignmentLeft;
    
}

@end
