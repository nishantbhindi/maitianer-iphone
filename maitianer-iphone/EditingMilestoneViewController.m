//
//  EditingMilestoneViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-12-21.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "EditingMilestoneViewController.h"
#import "AppDelegate.h"

@implementation EditingMilestoneViewController
@synthesize milestoneText = _milestoneText;
@synthesize milestone = _milestone;
@synthesize editing = _editing;

- (void)cancelEditing {
    [self.milestone.managedObjectContext deleteObject:self.milestone];
    NSError *error;
    if (![self.milestone.managedObjectContext save:&error]) {
        //handle the error
    };
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveEditing {
    self.milestoneText.text = [self.milestoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.editing) {
        self.milestone.content = self.milestoneText.text;
    }else {
        self.milestone.content = self.milestoneText.text;
        self.milestone.recordDate = self.milestone.photo.recordDate;
        self.milestone.creationDate = [NSDate date];
        
    }
    NSError *error;
    if ([self.milestone.managedObjectContext save:&error]) {
        //handle the error
    }
    if (self.editing) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
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
    [_milestoneText release];
    [_milestone release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set navigation bar background image for ios 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    }
    if (!self.editing) {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelEditing)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        [cancelBarButtonItem release];
    }
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveEditing)];
    [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    [saveBarButtonItem release];
    
    self.view.backgroundColor = RGBCOLOR(229, 234, 204);
    
    //custom text view appearance
    self.milestoneText.layer.borderWidth = 1;
    self.milestoneText.layer.borderColor = [UIColor blackColor].CGColor;
    self.milestoneText.layer.cornerRadius = 5;
    //show keyboard
    [self.milestoneText becomeFirstResponder];
    
    //set milestone text when editing
    self.milestoneText.text = self.milestone.content;
    
    
}

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

@end
