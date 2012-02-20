//
//  MTTabBarController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-19.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTabBar.h"
#import "PhotoPickerController.h"

@interface MTTabBarController : UIViewController <MTTabBarDelegate, PhotoPickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, readonly) MTTabBar *tabBar;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL tabBarHidden;

- (id)initWithControllers:(NSArray *)controllers;
- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated;

@end
