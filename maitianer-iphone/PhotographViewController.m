//
//  PhotographViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "PhotographViewController.h"
#import "DKFile.h"
#import "NSDate-Utilities.h"
#import "UIImage+ProportionalFill.h"

@implementation PhotographViewController
@synthesize imagePickerController = _imagePickerController;
@synthesize recordDate = _recordDate;

- (void)_showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePickerController.sourceType = sourceType;
        [self presentModalViewController:self.imagePickerController animated:YES];
    }else {
        NSLog(@"Source type invalid!");
    }
}

- (void)cameraAction:(id)sender {
    [self _showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)photoLibraryAction:(id)sender {
    [self _showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"拍照";
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        self.recordDate = [NSDate date];
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
    [_recordDate release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
- (void)_saveImage:(UIImage *)image {
    int year = self.recordDate.year;
    int month = self.recordDate.month;
    int day = self.recordDate.day;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@.jpg", (NSString *)uuidString];
    CFRelease(uuidString);
    
    DKFile *file = [DKFile fileFromDocuments:uniqueFileName];
    NSError *error = nil;
    if ([file writeData:UIImageJPEGRepresentation(image, 0.9) error:&error]) {
        NSLog(@"File save success!");
    }else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    //store the origin image picked
    [self _saveImage:originImage];
    
    //resize the origin image for thumbnail 640x640 and store it
    [self _saveImage:editedImage];
    
    //resize the origin image for thumbnail 200x200 and store it
    [self _saveImage:[editedImage imageScaledToFitSize:CGSizeMake(200, 200)]];
    
    //save the photo record use core data
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
