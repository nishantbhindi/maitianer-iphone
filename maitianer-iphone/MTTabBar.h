//
//  MTTabBar.h
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTTabBar;

@protocol MTTabBarDelegate <NSObject>
- (void)tabBar:(MTTabBar *)tabBar didSelectTabAtIndex:(NSInteger)index;
@end

@interface MTTabBar : UIView {
    UIImage *_backgroundImage;
    id <MTTabBarDelegate> delegate;
    NSMutableArray *_tabs;
}

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, assign) id <MTTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tabs;

@end
