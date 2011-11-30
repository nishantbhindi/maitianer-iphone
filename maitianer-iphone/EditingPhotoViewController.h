//
//  EditingPhotoViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-30.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface EditingPhotoViewController : UIViewController {
    IBOutlet UITextView *_textView;
    IBOutlet UIImageView *_imageView;
    Photo *_photo;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) Photo *photo;

- (void)cancelEditing;
- (void)saveEditing;

@end
