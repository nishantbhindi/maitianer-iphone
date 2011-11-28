//
//  PhotosViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "PhotosViewController.h"
#import "Photo.h"
#import "MTTableViewPhotoCell.h"
#import "UIImage+ProportionalFill.h"

@implementation PhotosViewController
@synthesize photos = _photos;
@synthesize milestones = _milestones;
@synthesize selectedIndexPath = _selectedIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [_photos release];
    [_milestones release];
    [_selectedIndexPath release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    MTTableViewPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MTTableViewPhotoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }else {
        //remove add milestone button from cell when reuse the cell
        if (cell.addMilestoneButton && [cell.contentView.subviews containsObject:cell.addMilestoneButton]) {
            [cell.addMilestoneButton removeFromSuperview];
        }
        
        //remove edit photo button from cell when reuse the cell
        if (cell.editPhotoButton && [cell.contentView.subviews containsObject:cell.editPhotoButton]) {
            [cell.editPhotoButton removeFromSuperview];
        }
    }
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        cell.imageView.image = photo.image;
        
        cell.addMilestoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cell.addMilestoneButton setTitle:@"添加里程碑" forState:UIControlStateNormal];
        cell.addMilestoneButton.frame = CGRectMake(260, 10, 50, 20);
        [cell.contentView addSubview:cell.addMilestoneButton];
        
        cell.editPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cell.editPhotoButton setTitle:@"编辑图片" forState:UIControlStateNormal];
        cell.editPhotoButton.frame = CGRectMake(260, 40, 50, 20);
        [cell.contentView addSubview:cell.editPhotoButton];
    }else {
        cell.imageView.image = [photo.image imageToFitSize:CGSizeMake(320, 80) method:MGImageResizeCrop];
    }
    
    if (photo.content) {
        cell.detailTextLabel.text = photo.content;
    }
    // Configure the cell...
    
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        return self.view.frame.size.width;
    }
    return 80;
}

@end
