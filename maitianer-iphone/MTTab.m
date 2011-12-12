//
//  MTTab.m
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTTab.h"

@implementation MTTab
@synthesize background = _background;
@synthesize rightBorder = _rightBorder;

- (id)initWithIconImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.background = [UIImage imageNamed:@"TabBackground.png"];
        self.rightBorder = [UIImage imageNamed:@"TabRightBorder.png"];
        self.backgroundColor = [UIColor clearColor];
        
        NSString *selectedName = [NSString stringWithFormat:@"%@-selected.%@", 
                                  [imageName stringByDeletingPathExtension],
                                  [imageName pathExtension]];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    }
    return self;
}

- (void)dealloc {
    [_background release];
    [_rightBorder release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    if (self.selected) {
        [self.background drawAtPoint:CGPointMake(0, 2)];
        [self.rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - self.rightBorder.size.width, 2)];
        CGContextRef c = UIGraphicsGetCurrentContext();
		[RGBCOLOR(24, 24, 24) set]; 
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
		[RGBCOLOR(14, 14, 14) set];		
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
                                                      (self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
                                                      (self.imageView.image.size.width / 2)),
												floor((self.bounds.size.height / 2) -
                                                      (self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
                                                      (self.imageView.image.size.width / 2)));
	self.imageEdgeInsets = imageInsets;
}

@end
