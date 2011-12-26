//
//  PhotosViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "PhotosViewController.h"
#import "Photo.h"
#import "UIImage+ProportionalFill.h"
#import "EditingPhotoViewController.h"
#import "EditingMilestoneViewController.h"
#import "AppDelegate.h"
#import "PhotographViewController.h"

#define PHOTO_TAG 1
#define DETAIL_LABEL_TAG 2
#define DATE_LABEL_TAG 3
#define ADD_MILESTONE_BUTTON_TAG 4
#define EDIT_PHOTO_BUTTON_TAG 5
#define PHOTO_WIDTH 300
#define SMALL_PHOTO_HEIGHT 80

@implementation PhotosViewController
@synthesize photos = _photos;
@synthesize milestones = _milestones;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize photographVC = _photographVC;

- (Photo *)selectedPhoto {
    if (self.selectedIndexPath) {
        return [self.photos objectAtIndex:self.selectedIndexPath.row];
    }
    return nil;
}

- (void)addMilestone {
    if (self.selectedPhoto) {
        EditingMilestoneViewController *editingMilestoneVC = [[EditingMilestoneViewController alloc] initWithNibName:@"EditingMilestoneViewController" bundle:[NSBundle mainBundle]];
        editingMilestoneVC.photo = self.selectedPhoto;
        editingMilestoneVC.title = @"添加里程碑";
        UINavigationController *editingMilestoneNVC = [[UINavigationController alloc] initWithRootViewController:editingMilestoneVC];
        [self presentModalViewController:editingMilestoneNVC animated:YES];
        [editingMilestoneVC release];
        [editingMilestoneNVC release];
    }
}

- (void)editPhoto {
    if (self.selectedPhoto) {
        EditingPhotoViewController *editingPhotoVC = [[EditingPhotoViewController alloc] initWithNibName:@"EditingPhotoViewController" bundle:[NSBundle mainBundle]];
        editingPhotoVC.photo = self.selectedPhoto;
        UINavigationController *editingPhotoNVC = [[UINavigationController alloc] initWithRootViewController:editingPhotoVC];
        [self presentModalViewController:editingPhotoNVC animated:YES];
        [editingPhotoVC release];
        [editingPhotoNVC release];
    }
}

- (void)removePhoto {
    if (self.selectedPhoto) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.managedObjectContext deleteObject:self.selectedPhoto];
        [appDelegate saveContext];
        [self.photos removeObjectAtIndex:self.selectedIndexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        if ([self.photos count] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"photo removed!");
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Must put here
        self.hidesBottomBarWhenPushed = YES;
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
    [_photos release];
    [_milestones release];
    [_selectedIndexPath release];
    [_photographVC release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(229, 234, 204);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //set navigation bar background image for ios 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.photographVC action:@selector(photoLibraryAction:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView reloadData];
    UIView *button = [self.tabBarController.view viewWithTag:9999];
    [button setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    UIImageView *photoView;
    UILabel *detailLabel;
    UIButton *addMilestoneButton;
    UIButton *editPhotoButton;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, PHOTO_WIDTH, PHOTO_WIDTH)];
        photoView.tag = PHOTO_TAG;
        [cell.contentView addSubview:photoView];
        [photoView release];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, PHOTO_WIDTH - 10, PHOTO_WIDTH, 25)];
        detailLabel.tag = DETAIL_LABEL_TAG;
        detailLabel.backgroundColor = [UIColor blackColor];
        detailLabel.alpha = 0.7;
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:detailLabel];
        [detailLabel release];
        
        addMilestoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addMilestoneButton.tag = ADD_MILESTONE_BUTTON_TAG;
        addMilestoneButton.frame = CGRectMake(10, 10, 80, 20);
        [addMilestoneButton setTitle:@"添加里程碑" forState:UIControlStateNormal];
        addMilestoneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [addMilestoneButton addTarget:self action:@selector(addMilestone) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addMilestoneButton];
        
        editPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editPhotoButton.tag = EDIT_PHOTO_BUTTON_TAG;
        editPhotoButton.frame = CGRectMake(260, 283, 50, 20);
        [editPhotoButton setTitle:@"编辑" forState:UIControlStateNormal];
        editPhotoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [editPhotoButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editPhotoButton];
    }else {
        photoView = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        detailLabel = (UILabel *)[cell.contentView viewWithTag:DETAIL_LABEL_TAG];
        addMilestoneButton = (UIButton *)[cell.contentView viewWithTag:ADD_MILESTONE_BUTTON_TAG];
        editPhotoButton = (UIButton *)[cell.contentView viewWithTag:EDIT_PHOTO_BUTTON_TAG];
    }
    
    // Configure the cell...
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    if (photo.milestone == nil) {
        addMilestoneButton.hidden = NO;
    }else {
        addMilestoneButton.hidden = YES;
    }
    
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        addMilestoneButton.hidden = NO;
        editPhotoButton.hidden = NO;
        
        photoView.image = photo.image;
        CGRect photoViewFrame = photoView.frame;
        photoViewFrame.size = CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH);
        photoView.frame = photoViewFrame;
        
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin = CGPointMake(10, PHOTO_WIDTH - 20);
        detailLabel.frame = detailLabelFrame;
    }else {
        addMilestoneButton.hidden = YES;
        editPhotoButton.hidden = YES;
        
        photoView.image = [photo.image imageToFitSize:CGSizeMake(PHOTO_WIDTH, 80) method:MGImageResizeCrop];
        CGRect photoViewFrame = photoView.frame;
        photoViewFrame.size = CGSizeMake(PHOTO_WIDTH, 80);
        photoView.frame = photoViewFrame;
        
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin = CGPointMake(10, photoViewFrame.size.height - 20);
        detailLabel.frame = detailLabelFrame;
    }
    
    if (photo.content && ![photo.content isEqualToString:@""]) {
        detailLabel.text = [NSString stringWithFormat:@"   %@", photo.content];
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.hidden = NO;
    }else {
        detailLabel.hidden = YES;
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.selectedIndexPath] != NSOrderedSame) {
        NSIndexPath *preSelectedIndexPath = [self.selectedIndexPath retain];
        self.selectedIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.selectedIndexPath, preSelectedIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [preSelectedIndexPath release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        return PHOTO_WIDTH + 10;
    }
    return SMALL_PHOTO_HEIGHT + 10;
}

@end
