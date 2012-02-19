//
//  MTTabBar.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-19.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PHOTO_PICKER_BUTTON_TAG 1

@class MTTabBar;

@protocol MTTabBarDelegate <NSObject>

- (void)tabBar:(MTTabBar *)tabBar didSelectedTabBarButtonWithTag:(NSInteger)tag;

@end

@interface MTTabBar : UIView

@property (nonatomic, assign) id <MTTabBarDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) IBOutlet UIButton *photoPickerButton;
@property (nonatomic, retain) IBOutlet UIButton *milestoneButton;

- (IBAction)tabBarButtonClicked:(UIButton *)sender;
- (void)deselectAllTabBarButtons;

@end
