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
        UIImageView *innerImageView = [[UIImageView alloc] initWithImage:firstPhoto.b200Image];
        innerImageView.frame = self.bounds;
        innerImageView.layer.cornerRadius = 5;
        innerImageView.layer.masksToBounds = YES;
        [self addSubview:innerImageView];
        [innerImageView release];
        //[self setBackgroundImage:firstPhoto.b200Image forState:UIControlStateNormal];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageNamed:@"no-photo"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 1.5);
        self.layer.shadowRadius = 0;
        self.layer.shadowColor = [UIColor colorWithRed:193.0/255 green:208.0/255 blue:148.0/255 alpha:1.0].CGColor;
        self.layer.shadowOpacity = 1;
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
