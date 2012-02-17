//
//  MTCaptionView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-17.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "MTCaptionView.h"
#import "Photo.h"

static const CGFloat labelPadding = 10;

// Private
@interface MTCaptionView () {
    id<MTPhotoProtocol> _photo;
    UILabel *_label;    
}
@end

@implementation MTCaptionView

- (id)initWithPhoto:(id<MTPhotoProtocol>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        _photo = [photo retain];
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self setupCaption];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = 9999;
    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
    CGSize textSize = [_label.text sizeWithFont:_label.font 
                              constrainedToSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                  lineBreakMode:_label.lineBreakMode];
    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
}

- (void)setupCaption {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, 0, 
                                                       self.bounds.size.width-labelPadding*2,
                                                       self.bounds.size.height)];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = UITextAlignmentCenter;
    _label.lineBreakMode = UILineBreakModeWordWrap;
    _label.numberOfLines = 3;
    _label.textColor = [UIColor whiteColor];
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(1, 1);
    _label.font = [UIFont systemFontOfSize:17];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _label.text = [_photo caption] ? [_photo caption] : @" ";
    }
    
    [self addSubview:_label];
}

- (void)dealloc {
    [_label release];
    [_photo release];
    [super dealloc];
}

@end
