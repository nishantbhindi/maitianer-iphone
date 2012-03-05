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
@synthesize innerImageView = _innerImageView;
@synthesize dateImageView = _dateImageView;

- (void)setDate:(NSDate *)date {
    if (![date isEqualToDate:_date]) {
        [_date release];
        _date = [date retain];
        UIImage *image = [UIImage imageNamed:@"date-background-enable"];
        if (self.enabled == NO) {
            image = [UIImage imageNamed:@"date-background-disable"];
        }
        if ([_date isToday]) {
            image = [UIImage imageNamed:@"date-background-today"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.dateImageView = imageView;
        [imageView release];
        //[self setTitle:[NSString stringWithFormat:@"%d", _date.day] forState:UIControlStateNormal];
    }
}

- (void)setPhotos:(NSArray *)photos {
    if (photos != _photos) {
        [_photos release];
        _photos = [photos retain];
        Photo *lastPhoto = [_photos lastObject];
        UIImageView *innerImageView = [[UIImageView alloc] initWithImage:lastPhoto.b140Image];
        self.innerImageView = innerImageView;
        [innerImageView release];
        BOOL flag = NO;
        for (Photo *photo in _photos) {
            if (photo.milestone != nil) {
                flag = YES;
                break;
            }
        }
        if (flag) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -5.5, 30, 30)];
            imageView.image = [UIImage imageNamed:@"date-background-milestone.png"];
            self.dateImageView = imageView;
            [imageView release];
        }
        
        //[self setBackgroundImage:firstPhoto.b200Image forState:UIControlStateNormal];
    }
}

- (void)setInnerImageView:(UIImageView *)innerImageView {
    if (innerImageView != _innerImageView) {
        [_innerImageView removeFromSuperview];
        [_innerImageView release];
        _innerImageView = [innerImageView retain];
        _innerImageView.frame = self.bounds;
        //_innerImageView.layer.masksToBounds = YES;
        //_innerImageView.layer.cornerRadius = 5;
        [self insertSubview:innerImageView atIndex:0];
    }
}

- (void)setDateImageView:(UIImageView *)dateImageView {
    if (dateImageView != _dateImageView) {
        [_dateImageView removeFromSuperview];
        [_dateImageView release];
        _dateImageView = [dateImageView retain];
        //_dateImageView.layer.masksToBounds = YES;
        //_dateImageView.layer.cornerRadius = 5;
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 3, 20, 10)];
        dateLabel.textAlignment = UITextAlignmentCenter;
        dateLabel.text = [NSString stringWithFormat:@"%d", _date.day];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:10];
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        [self addSubview:self.dateImageView];
        [self bringSubviewToFront:dateLabel];
        [dateLabel release];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *noPhotoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-photo"]];
        self.innerImageView = noPhotoImageView;
//        self.layer.cornerRadius = 5;
//        self.layer.shadowOffset = CGSizeMake(0, 1.5);
//        self.layer.shadowRadius = 0;
//        self.layer.shadowColor = RGBCOLOR(193, 208, 148).CGColor;
//        self.layer.shadowOpacity = 1;
    }
    return self;
}

- (void)dealloc {
    [_date release];
    [_photos release];
    [_innerImageView release];
    [_dateImageView release];
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
