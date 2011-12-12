//
//  MTTab.h
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTab : UIButton {
    UIImage *_background;
    UIImage *_rightBorder;
}

@property (nonatomic, retain) UIImage *background;
@property (nonatomic, retain) UIImage *rightBorder;

- (id)initWithIconImageName:(NSString *)imageName;

@end
