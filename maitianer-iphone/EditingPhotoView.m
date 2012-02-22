//
//  EditingPhotoView.m
//  maitianer-iphone
//
//  Created by lee rock on 12-2-22.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "EditingPhotoView.h"
#import "Photo.h"

@interface EditingPhotoView ()

@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UITextView *contentTextView;
@property (nonatomic, retain) UIImageView *backgroundView;
    
@end

@implementation EditingPhotoView
@synthesize delegate = _delegate;
@synthesize photo = _photo;
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
@synthesize contentTextView = _contentTextView;
@synthesize backgroundView = _backgroundView;

- (id)initWithPhoto:(Photo *)photo {
    self = [self init];
    if (self) {
        _photo = [photo retain];
    }
    
    _backgroundView = [[UIImageView alloc] init];
    [self addSubview:_backgroundView];
    
    _saveButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_saveButton addTarget:self action:@selector(finishEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];
    
    _cancelButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_cancelButton addTarget:self action:@selector(cancelEditing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.editable = YES;
    _contentTextView.delegate = self;
    _contentTextView.font = [UIFont systemFontOfSize:16];
    [self addSubview:_contentTextView];
    return self;
}

- (void)dealloc {
    [_photo release];
    [_saveButton release];
    [_cancelButton release];
    [_contentTextView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.saveButton.frame = CGRectMake(self.bounds.size.width - 10 - 30, 10, 30, 20);
    self.cancelButton.frame = CGRectMake(10, 10, 30, 20);
    self.contentTextView.frame = CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height - 40);
}

#pragma mark - Actions
- (void)finishEditing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didFinishEditingPhotoView:)]) {
        [self.delegate didFinishEditingPhotoView:self];
    }
}

- (void)cancelEditing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelEditingPhotoView:)]) {
        [self.delegate didCancelEditingPhotoView:self];
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

@end
