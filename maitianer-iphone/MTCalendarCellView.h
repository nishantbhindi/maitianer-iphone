//
//  MTCalendarCellView.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MTCalendarCellView : UIButton {
    NSDate *_date;
    NSArray *_photos;
    UIImageView *_innerImageView;
    UIImageView *_dateImageView;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) UIImageView *innerImageView;
@property (nonatomic, retain) UIImageView *dateImageView;

@end
