//
//  MTCalendarView.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCalendarCellView.h"

@protocol MTCalendarViewDelegate;

@interface MTCalendarView : UIView {
    NSDate *_selectedDate;
    NSDate *_miniumDate;
    
    UIView *_monthBar;
    UIButton *_monthLabelButton;
    UIButton *_monthBackButton;
    UIButton *_monthForwardButton;
    UIScrollView *_calendarScrollView;
}

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *miniumDate;
@property (readonly) UIView *monthBar;
@property (readonly) UIButton *monthLabelButton;
@property (readonly) UIButton *monthBackButton;
@property (readonly) UIButton *monthForwardButton;
@property (readonly) UIScrollView *calendarScrollView;

@property (assign) id<MTCalendarViewDelegate> delegate;

- (MTCalendarCellView *)cellForDate:(NSDate *)date;

- (void) monthForward;
- (void) monthBack;

@end

@protocol MTCalendarViewDelegate <NSObject>

- (void) calendarView:(MTCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end
