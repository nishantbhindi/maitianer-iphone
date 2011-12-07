//
//  MTTableViewPhotoCell.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-28.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MTTableViewPhotoCell : UITableViewCell {
    UIButton *_addMilestoneButton;
    UIButton *_editPhotoButton;
    UIButton *_removePhotoButton;
}

@property (nonatomic, retain) UIButton *addMilestoneButton;
@property (nonatomic, retain) UIButton *editPhotoButton;
@property (nonatomic, retain) UIButton *removePhotoButton;

@end
