//
//  EditingPhotoView.h
//  maitianer-iphone
//
//  Created by lee rock on 12-2-22.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;
@class EditingView;

@protocol EditingViewDelegate <NSObject>
- (void)didFinishEditingView:(EditingView *)editingView;
- (void)didCancelEditingView:(EditingView *)editingView;
@end

@interface EditingView : UIView

- (id)initWithTitle:(NSString *)title Entity:(NSManagedObject *)entity;
@property (nonatomic, assign) id <EditingViewDelegate> delegate;
@property (nonatomic, retain) NSManagedObject *entity;
@property (nonatomic, retain) UITextView *contentTextView;

- (void)finishEditing:(id)sender;
- (void)cancelEditing:(id)sender;

@end
