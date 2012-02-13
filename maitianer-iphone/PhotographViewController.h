//
//  PhotographViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@class Photo;
@class Baby;

@interface PhotographViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ASIHTTPRequestDelegate> {
    
    UIImagePickerController *_imagePickerController;
    NSDate *_recordDate;
    Photo *_photo;
    Baby *_baby;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSDate *recordDate;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Baby *baby;

- (void)cameraAction:(id)sender;
- (void)photoLibraryAction:(id)sender;

@end
