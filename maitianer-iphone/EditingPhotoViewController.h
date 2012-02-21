//
//  EditingPhotoViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-30.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WBEngine.h"
#import "WBRequest.h"
#import "JSONRequest.h"

@class Photo;

@interface EditingPhotoViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, WBEngineDelegate, WBRequestDelegate, JSONRequestDelegate> {
    IBOutlet UITextField *_photoText;
    IBOutlet UIImageView *_imageView;
    IBOutlet UISwitch *_shareSwitch;
    Photo *_photo;
}

@property (nonatomic, retain) UITextField *photoText;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UISwitch *shareSwitch;
@property (nonatomic, retain) Photo *photo;

@property (nonatomic, retain) WBEngine *wbEngine;

- (void)cancelEditing;
- (void)saveEditing;
- (IBAction)removePhoto;
- (IBAction)shareSwitchValueChanged:(UISwitch *)sender;

@end
