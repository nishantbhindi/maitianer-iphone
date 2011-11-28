//
//  MTCalendarCellView.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCalendarCellView : UIButton {
    NSDate *_date;
    NSArray *_photos;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSArray *photos;

@end
