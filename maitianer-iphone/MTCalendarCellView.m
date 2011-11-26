//
//  MTCalendarCellView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-23.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MTCalendarCellView.h"
#import "NSDate-Utilities.h"
#import "DKFile.h"

@implementation MTCalendarCellView
@synthesize date = _date;
@synthesize photo = _photo;

- (void)setDate:(NSDate *)date {
    if (![date isEqualToDate:_date]) {
        [_date release];
        _date = [date retain];
        [self setTitle:[NSString stringWithFormat:@"%d", _date.day] forState:UIControlStateNormal];
    }
}

- (void)setPhoto:(Photo *)photo {
    if (photo != _photo) {
        [_photo release];
        _photo = [photo retain];
        DKFile *dkFile = [DKFile fileFromDocuments:_photo.path];
        [self setBackgroundImage:[UIImage imageWithContentsOfFile:dkFile.path] forState:UIControlStateNormal];
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
    [_photo release];
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
