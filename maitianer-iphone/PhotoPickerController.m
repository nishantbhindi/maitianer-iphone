//
//  PhotographViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "PhotoPickerController.h"
#import "DKFile.h"
#import "NSDate-Utilities.h"
#import "NSDate+Calculations.h"
#import "UIImage+ProportionalFill.h"
#import "Photo.h"
#import "FlurryAnalytics.h"
#import "Utilities.h"
#import "Baby.h"
#import "Authorization.h"

@interface PhotoPickerController ()

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) BOOL isFrommCamera;

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType;
    
@end


@implementation PhotoPickerController
@synthesize delegate = _delegate;
@synthesize recordDate = _recordDate;
@synthesize imagePickerController = _imagePickerController;
@synthesize isFrommCamera = _isFromCamera;

- (void)cameraAction {
    self.isFrommCamera = YES;
    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)photoLibraryAction {
    self.isFrommCamera = NO;
    [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - Private
- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePickerController.sourceType = sourceType;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            [FlurryAnalytics logEvent:@"TakePhotoFromCamera"];
        }else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [FlurryAnalytics logEvent:@"TakePhotoFromPhotoLibrary"];
        }
        if ([self.delegate respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self.delegate presentModalViewController:self.imagePickerController animated:YES];
        }else {
            [self presentModalViewController:self.imagePickerController animated:YES];
        }
    }else {
        NSLog(@"Source type invalid!");
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"拍照";
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return self;
}

- (id)initWithDelegate:(id)delegate {
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [_imagePickerController release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Image picker controller delegate methods
- (void)_saveImage:(UIImage *)image toPath:(NSString *)path{
    
    DKFile *file = [DKFile fileFromDocuments:path];
    NSError *error = nil;
    if ([file writeData:UIImageJPEGRepresentation(image, 0.9) error:&error]) {
        NSLog(@"File save success!");
    }else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (NSString *)_photoStorePathByDate:(NSDate *)date {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *subPath = [NSString stringWithFormat:@"photos/%d/%d/%d", year, month, day];
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:subPath];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		if (![[NSFileManager defaultManager] createDirectoryAtPath:path
									   withIntermediateDirectories:YES
														attributes:nil
															 error:&error]) {
			NSLog(@"Create directory error: %@", error);
		}
	}
    
    return subPath;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if ([self.delegate respondsToSelector:@selector(photoPickerController:didFinishPickingImage:isFromCamera:)]) {
        [self.delegate photoPickerController:self didFinishPickingImage:originImage isFromCamera:self.isFrommCamera];
    }
    
    // Dismiss the modal view when finish
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Dismiss the modal view when finish
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

@end
