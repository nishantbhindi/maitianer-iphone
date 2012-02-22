//
//  EditingPhotoView.h
//  maitianer-iphone
//
//  Created by lee rock on 12-2-22.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;
@class EditingPhotoView;

@protocol EditingPhotoViewDelegate <NSObject>
@optional
- (void)didFinishEditingPhotoView:(EditingPhotoView *)editingPhotoView;
- (void)didCancelEditingPhotoView:(EditingPhotoView *)editingPhotoView;
@end

@interface EditingPhotoView : UIView <UITextViewDelegate>

- (id)initWithPhoto:(Photo *)photo;

@property (nonatomic, assign) id <EditingPhotoViewDelegate> delegate;
@property (nonatomic, retain) Photo *photo;

- (void)finishEditing:(id)sender;
- (void)cancelEditing:(id)sender;

@end
