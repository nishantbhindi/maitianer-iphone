//
//  PhotographViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;
@class Baby;
@class PhotoPickerController;

@protocol PhotoPickerControllerDelegate <NSObject>
@optional
- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera;

@end

@interface PhotoPickerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSDate *recordDate;

- (id)initWithDelegate:(id)delegate;
- (void)cameraAction;
- (void)photoLibraryAction;

@end
