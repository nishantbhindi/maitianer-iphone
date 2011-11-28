//
//  MTCalendarCellView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTCalendarCellView.h"
#import "NSDate-Utilities.h"
#import "Photo.h"

@implementation MTCalendarCellView
@synthesize date = _date;
@synthesize photos = _photos;

- (void)setDate:(NSDate *)date {
    if (![date isEqualToDate:_date]) {
        [_date release];
        _date = [date retain];
        [self setTitle:[NSString stringWithFormat:@"%d", _date.day] forState:UIControlStateNormal];
    }
}

- (void)setPhotos:(NSArray *)photos {
    if (photos != _photos) {
        [_photos release];
        _photos = [photos retain];
        Photo *firstPhoto = [_photos objectAtIndex:0];
        [self setBackgroundImage:firstPhoto.b200Image forState:UIControlStateNormal];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)dealloc {
    [_date release];
    [_photos release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
