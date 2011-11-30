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
#import "NSDate+Calculations.h"
#import "UIImage+ProportionalFill.h"
#import "Photo.h"
#import "AppDelegate.h"

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
- (void)_saveImage:(UIImage *)image toPath:(NSString *)path{
    
    DKFile *file = [DKFile fileFromDocuments:path];
    NSError *error = nil;
    if ([file writeData:UIImageJPEGRepresentation(image, 0.9) error:&error]) {
        NSLog(@"File save success!");
    }else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (NSString *)_generateUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@", (NSString *)uuidString];
    CFRelease(uuidString);
    return uniqueFileName;
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

- (NSArray *)_fetchBabies {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //fetch babies from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Baby"];
    NSError *error = nil;
    NSArray *babiesArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (babiesArray == nil) {
        //Handle the error.
    }
    NSLog(@"babies count: %d", [babiesArray count]);
    return babiesArray;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSString *storePath = [self _photoStorePathByDate:self.recordDate];
    NSString *fileNameUUID = [self _generateUUID];
    
    //store the origin image picked
    [self _saveImage:originImage 
              toPath:[storePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-origin.jpg", fileNameUUID]]];
    
    //resize the origin image for thumbnail 640x640 and store it
    [self _saveImage:editedImage 
              toPath:[storePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileNameUUID]]];
    
    //resize the origin image for thumbnail 200x200 and store it
    [self _saveImage:[editedImage imageScaledToFitSize:CGSizeMake(200, 200)] 
              toPath:[storePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-b200.jpg", fileNameUUID]]];
    
    //save the photo record use core data
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:appDelegate.managedObjectContext];
    photo.path = [storePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileNameUUID]];
    photo.baby = [[self _fetchBabies] objectAtIndex:0];
    photo.recordDate = [self.recordDate beginningOfDay];
    photo.creationDate = [NSDate date];
    photo.shared = [NSNumber numberWithBool:NO];
    
    [appDelegate saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
    
    //when dismiss modal view reset the record date to now
    self.recordDate = [[NSDate date] beginningOfDay];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
    //when dismiss modal view reset the record date to now
    self.recordDate = [[NSDate date] beginningOfDay];
}

@end
