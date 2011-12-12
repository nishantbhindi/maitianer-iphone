//
//  MTTabBar.m
//  maitianer-iphone
//
//  Created by lee rock on 11-12-10.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTTabBar.h"
#import "MTTab.h"
#define kTabMargin 2.0

@implementation MTTabBar
@synthesize backgroundImage = _backgroundImage;
@synthesize delegate;
@synthesize tabs = _tabs;

- (void)tabSelected:(MTTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
    for (MTTab *tab in self.tabs) {
        tab.selected = NO;
    }
    sender.selected = YES;
}

- (void)setTabs:(NSMutableArray *)tabs {
    if (_tabs != tabs) {
        for (MTTab *tab in _tabs) {
            [tab removeFromSuperview];
        }
        [_tabs release];
        _tabs = [tabs retain];
        for (MTTab *tab in _tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tab];
        }
        [self tabSelected:[tabs objectAtIndex:0]];
        [self setNeedsLayout];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
        UIViewAutoresizingFlexibleTopMargin;
        self.userInteractionEnabled = YES;
        
        self.backgroundImage = [UIImage imageNamed:@"TabBarGradient.png"];
    }
    return self;
}

- (void)dealloc {
    [_backgroundImage release];
    [_tabs release];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.backgroundImage drawAtPoint:CGPointMake(0, 0)];
    [[UIColor blackColor] set];
    CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height /2));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f = self.bounds;
    f.size.width /= self.tabs.count;
    f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
    for (MTTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = CGRectMake(floorf(f.origin.x), f.origin.y, floorf(f.size.width), f.size.height);
		f.origin.x += f.size.width;
	}
}


@end
