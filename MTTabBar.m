//
//  MTTabBar.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-19.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "MTTabBar.h"

@implementation MTTabBar
@synthesize delegate = _delegate;
@synthesize calendarButton = _calendarButton;
@synthesize photoPickerButton = _photoPickerButton;
@synthesize milestoneButton = _milestoneButton;

- (void)dealloc {
    [_calendarButton release];
    [_photoPickerButton release];
    [_milestoneButton release];
    [super dealloc];
}

- (void)tabBarButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedTabBarButtonWithTag:)]) {
        [self.delegate tabBar:self didSelectedTabBarButtonWithTag:sender.tag];
        if (sender.tag != PHOTO_PICKER_BUTTON_TAG) {
            [self deselectAllTabBarButtons];
            sender.selected = YES;
        }
        
    }
}

- (void)deselectAllTabBarButtons {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
        }
        
    }
}

@end
