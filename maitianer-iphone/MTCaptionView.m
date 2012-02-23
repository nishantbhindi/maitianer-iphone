//
//  MTCaptionView.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-23.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "MTCaptionView.h"
#import "Photo.h"
#import "Milestone.h"

static const CGFloat labelPadding = 10;

@interface MTCaptionView () {
    UIImageView *_imageView;
    UILabel *_contentLabel;
}
@property (nonatomic, retain) UILabel *contentLabel;
@end

@implementation MTCaptionView
@synthesize contentLabel = _contentLabel;

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithPhoto:photo];
    if (self) {
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = 9999;
    if (_contentLabel.numberOfLines > 0) maxHeight = _contentLabel.font.leading*_contentLabel.numberOfLines;
    CGSize textSize = [_contentLabel.text sizeWithFont:_contentLabel.font 
                              constrainedToSize:CGSizeMake(self.bounds.size.width-labelPadding - 40, maxHeight)
                                  lineBreakMode:_contentLabel.lineBreakMode];
    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
}

- (void)setupCaption {
    
    if ([self.subviews containsObject:_contentLabel]) {
        [_contentLabel removeFromSuperview];
        [_contentLabel release];
        _contentLabel = nil;
        [_imageView removeFromSuperview];
        [_imageView release];
        _imageView = nil;
    }
    
    Photo *photo = [self valueForKey:@"_photo"];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 
                                                       self.bounds.size.width-labelPadding - 40,
                                                       self.bounds.size.height)];
    _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentLabel.opaque = NO;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = UITextAlignmentCenter;
    _contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    _contentLabel.numberOfLines = 3;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.shadowColor = [UIColor blackColor];
    _contentLabel.shadowOffset = CGSizeMake(1, 1);
    _contentLabel.font = [UIFont systemFontOfSize:17];
    
    if ([photo respondsToSelector:@selector(caption)]) {
        _contentLabel.text = [photo caption] ? [photo caption] : @" ";
    }
    [self addSubview:_contentLabel];
    
    if (photo.milestone) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milestone-star.png"]];
    }else {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-description.png"]];
    }
    _imageView.frame = CGRectMake(5, (self.bounds.size.height - 30) / 2, 30, 30);
    [self addSubview:_imageView];
    
}

- (void)dealloc {
    [_imageView release];
    [_contentLabel release];
    [super dealloc];
}

@end
