//
//  EditingPhotoViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-30.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Photo;

@interface EditingPhotoViewController : UIViewController {
    IBOutlet UITextField *_milestoneText;
    IBOutlet UITextField *_photoText;
    IBOutlet UIImageView *_imageView;
    Photo *_photo;
}

@property (nonatomic, retain) UITextField *milestoneText;
@property (nonatomic, retain) UITextField *photoText;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) Photo *photo;

- (void)cancelEditing;
- (void)saveEditing;

@end
