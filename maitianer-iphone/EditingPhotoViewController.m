//
//  EditingPhotoViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-30.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "EditingPhotoViewController.h"
#import "Photo.h"
#import "AppDelegate.h"

@implementation EditingPhotoViewController
@synthesize textView = _textView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;

- (void)setPhoto:(Photo *)photo {
    if (_photo != photo) {
        [_photo release];
        _photo = [photo retain];
        
        self.textView.text = _photo.content;
        self.imageView.image = _photo.image;
    }
}

- (void)cancelEditing {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveEditing {
    self.photo.content = self.textView.text;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [_textView release];
    [_imageView release];
    [_photo release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEditing)];
    [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.photo) {
        self.textView.text = self.photo.content;
        self.imageView.image = self.photo.image;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
