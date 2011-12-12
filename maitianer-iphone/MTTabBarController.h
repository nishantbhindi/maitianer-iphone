//
//  MTTabBarController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTabBar.h"

@interface MTTabBarController : UIViewController <MTTabBarDelegate> {
    MTTabBar *_tabBar;
    NSArray *_viewControllers;
    UIViewController *_selectedViewController;
    UIView *_contentView;
}

@property (nonatomic, retain) MTTabBar *tabBar;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) UIView *contentView;

@end
