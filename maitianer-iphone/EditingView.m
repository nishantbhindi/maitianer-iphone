//
//  EditingPhotoView.m
//  maitianer-iphone
//
//  Created by lee rock on 12-2-22.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "EditingView.h"
#import "Photo.h"

@interface EditingView ()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIImageView *backgroundView;
    
@end

@implementation EditingView
@synthesize delegate = _delegate;
@synthesize entity = _entity;
@synthesize titleLabel = _titleLabel;
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
@synthesize contentTextView = _contentTextView;
@synthesize backgroundView = _backgroundView;

- (id)initWithTitle:(NSString *)title Entity:entity {
    self = [self init];
    if (self) {
        _entity = [entity retain];
    }
    
    _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editing-view-bg.png"]];
    [self addSubview:_backgroundView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = title;
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_saveButton setBackgroundImage:[UIImage imageNamed:@"button-red.png"] forState:UIControlStateNormal];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _saveButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_saveButton addTarget:self action:@selector(finishEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];
    
    _cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"button-black.png"] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_cancelButton addTarget:self action:@selector(cancelEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.editable = YES;
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.returnKeyType = UIReturnKeyNext;
    _contentTextView.textColor = [UIColor whiteColor];
    [self addSubview:_contentTextView];
    return self;
}

- (void)dealloc {
    [_entity release];
    [_saveButton release];
    [_cancelButton release];
    [_contentTextView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake((self.bounds.size.width - 150)/2,  15, 150, 20);
    self.saveButton.frame = CGRectMake(self.bounds.size.width - 15 - 50, 8, 55, 33);
    self.cancelButton.frame = CGRectMake(15, 8, 55, 33);
    self.contentTextView.frame = CGRectMake(15, 40, self.bounds.size.width - 15, self.bounds.size.height - 40);
}

#pragma mark - Actions
- (void)finishEditing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didFinishEditingView:)]) {
        [self.delegate didFinishEditingView:self];
    }
}

- (void)cancelEditing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelEditingView:)]) {
        [self.delegate didCancelEditingView:self];
    }
}
@end
