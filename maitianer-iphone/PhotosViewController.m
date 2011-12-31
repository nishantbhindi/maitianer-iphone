//
//  PhotosViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "PhotosViewController.h"
#import "Photo.h"
#import "UIImage+ProportionalFill.h"
#import "EditingPhotoViewController.h"
#import "EditingMilestoneViewController.h"
#import "PhotographViewController.h"

#define PHOTO_TAG 1
#define DETAIL_LABEL_TAG 2
#define DATE_LABEL_TAG 3
#define ADD_MILESTONE_BUTTON_TAG 4
#define EDIT_PHOTO_BUTTON_TAG 5
#define MILESTONE_VIEW_TAG 6
#define MILESTONE_LABEL_TAG 7
#define PHOTO_WIDTH 300
#define SMALL_PHOTO_HEIGHT 80

@implementation PhotosViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedRequestController = _fetchedRequestController;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize recordDate = _recordDate;

- (Photo *)selectedPhoto {
    if (self.selectedIndexPath) {
        return [self.fetchedRequestController objectAtIndexPath:self.selectedIndexPath];
    }
    return nil;
}

- (void)addMilestone {
    if (self.selectedPhoto) {
        EditingMilestoneViewController *editingMilestoneVC = [[EditingMilestoneViewController alloc] initWithNibName:@"EditingMilestoneViewController" bundle:[NSBundle mainBundle]];
        Milestone *milestone = [NSEntityDescription insertNewObjectForEntityForName:@"Milestone" inManagedObjectContext:self.managedObjectContext];
        milestone.photo = self.selectedPhoto;
        editingMilestoneVC.milestone = milestone;
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Must put here
        self.hidesBottomBarWhenPushed = YES;
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
    [_managedObjectContext release];
    [_fetchedRequestController release];
    [_selectedIndexPath release];
    [_recordDate release];
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
    
    PhotographViewController *photographVC = [self.tabBarController.viewControllers objectAtIndex:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:photographVC action:@selector(photoLibraryAction:)];
    
    //set controller title
    NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
    dateFormattor.dateFormat = @"yyyy年MM月dd日";
    self.title = [dateFormattor stringFromDate:self.recordDate];
    [dateFormattor release];
    
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
    
    NSError *error;
    if (![self.fetchedRequestController performFetch:&error]) {
        //handle the error
    }
    
    if ([self.fetchedRequestController.fetchedObjects count] > 0) {
        [self.tableView reloadData];
    }else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    //hidden button
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

#pragma mark - fetched request controller
- (NSFetchedResultsController *)fetchedRequestController {
    if (_fetchedRequestController) {
        return _fetchedRequestController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"recordDate = %@", self.recordDate]];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    _fetchedRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [request release];
    return _fetchedRequestController;
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
    return [self.fetchedRequestController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    UIImageView *photoView;
    UILabel *detailLabel;
    UIButton *addMilestoneButton;
    UIButton *editPhotoButton;
    UIView *milestoneView;
    UILabel *milestoneLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, PHOTO_WIDTH, PHOTO_WIDTH)];
        photoView.tag = PHOTO_TAG;
        photoView.layer.cornerRadius = 5;
        photoView.layer.masksToBounds = YES;
        [cell.contentView addSubview:photoView];
        [photoView release];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PHOTO_WIDTH - 25, PHOTO_WIDTH, 25)];
        detailLabel.tag = DETAIL_LABEL_TAG;
        detailLabel.backgroundColor = [UIColor blackColor];
        detailLabel.alpha = 0.7;
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.textAlignment = UITextAlignmentLeft;
        [photoView addSubview:detailLabel];
        [detailLabel release];
        
        addMilestoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addMilestoneButton.tag = ADD_MILESTONE_BUTTON_TAG;
        addMilestoneButton.frame = CGRectMake(3, 1, 76, 70);
        [addMilestoneButton setBackgroundImage:[UIImage imageNamed:@"add-milestone-button.png"] forState:UIControlStateNormal];
        [addMilestoneButton addTarget:self action:@selector(addMilestone) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addMilestoneButton];
        
        editPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editPhotoButton.tag = EDIT_PHOTO_BUTTON_TAG;
        editPhotoButton.frame = CGRectMake(255, 283.5, 50, 18);
        [editPhotoButton setBackgroundImage:[UIImage imageNamed:@"edit-photo-button.png"] forState:UIControlStateNormal];
        [editPhotoButton setTitle:@"编辑" forState:UIControlStateNormal];
        editPhotoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [editPhotoButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editPhotoButton];
        
        milestoneView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        milestoneView.tag = MILESTONE_VIEW_TAG;
        milestoneView.backgroundColor = RGBCOLOR(254, 253, 223);
        milestoneView.hidden = YES;
        milestoneView.layer.cornerRadius = 5;
        [cell.contentView addSubview:milestoneView];
        [milestoneView release];
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        starImageView.image = [UIImage imageNamed:@"milestone-star.png"];
        [milestoneView addSubview:starImageView];
        [starImageView release];
        
        milestoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 240, 40)];
        milestoneLabel.tag = MILESTONE_LABEL_TAG;
        milestoneLabel.backgroundColor = [UIColor clearColor];
        milestoneLabel.font = [UIFont systemFontOfSize:14];
        milestoneLabel.textColor = RGBCOLOR(90, 86, 18);
        milestoneLabel.numberOfLines = 2;
        [milestoneView addSubview:milestoneLabel];
        [milestoneLabel release];
    }else {
        photoView = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        photoView.frame = CGRectMake(10, 5, PHOTO_WIDTH, PHOTO_WIDTH);
        detailLabel = (UILabel *)[photoView viewWithTag:DETAIL_LABEL_TAG];
        addMilestoneButton = (UIButton *)[cell.contentView viewWithTag:ADD_MILESTONE_BUTTON_TAG];
        editPhotoButton = (UIButton *)[cell.contentView viewWithTag:EDIT_PHOTO_BUTTON_TAG];
        editPhotoButton.frame = CGRectMake(255, 283.5, 50, 18);
        milestoneView = (UIView *)[cell.contentView viewWithTag:MILESTONE_VIEW_TAG];
        milestoneLabel = (UILabel *)[milestoneView viewWithTag:MILESTONE_LABEL_TAG];
    }
    
    // Configure the cell...
    Photo *photo = [self.fetchedRequestController objectAtIndexPath:indexPath];
    
    // is image selected
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        addMilestoneButton.hidden = NO;
        editPhotoButton.hidden = NO;
        
        photoView.image = photo.image;
        CGRect photoViewFrame = photoView.frame;
        photoViewFrame.size = CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH);
        photoView.frame = photoViewFrame;
        
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin = CGPointMake(0, PHOTO_WIDTH - 25);
        detailLabel.frame = detailLabelFrame;
    }else {
        addMilestoneButton.hidden = YES;
        editPhotoButton.hidden = YES;
        
        photoView.image = [photo.image imageToFitSize:CGSizeMake(PHOTO_WIDTH, 80) method:MGImageResizeCrop];
        CGRect photoViewFrame = photoView.frame;
        photoViewFrame.size = CGSizeMake(PHOTO_WIDTH, 80);
        photoView.frame = photoViewFrame;
        
        CGRect detailLabelFrame = detailLabel.frame;
        detailLabelFrame.origin = CGPointMake(0, photoViewFrame.size.height - 25);
        detailLabel.frame = detailLabelFrame;
    }
    
    // is image had milestone
    if (photo.milestone == nil) {
        milestoneView.hidden = YES;
    }else {
        addMilestoneButton.hidden = YES;
        milestoneView.hidden = NO;
        CGRect photoViewFrame = photoView.frame;
        photoViewFrame.origin.y += 45;
        photoView.frame = photoViewFrame;
        
        CGRect editPhotoButtonFrame = editPhotoButton.frame;
        editPhotoButtonFrame.origin.y += 45;
        editPhotoButton.frame = editPhotoButtonFrame;
        
        milestoneLabel.text = photo.milestone.content;
    }
    
    // is image had content
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
    CGFloat photoHeight = SMALL_PHOTO_HEIGHT;
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        photoHeight = PHOTO_WIDTH;
    }
    photoHeight += 10;
    
    Photo *photo = [self.fetchedRequestController objectAtIndexPath:indexPath];
    if (photo.milestone) {
        photoHeight += 45;
    }
    
    return photoHeight;
}

@end
