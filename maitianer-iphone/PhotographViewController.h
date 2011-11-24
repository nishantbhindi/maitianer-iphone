//
//  PhotographViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotographViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSManagedObjectContext *_managedObjectContext;
    
    UIImagePickerController *_imagePickerController;
    NSDate *_recordDate;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) NSDate *recordDate;

- (void)cameraAction:(id)sender;
- (void)photoLibraryAction:(id)sender;

@end
