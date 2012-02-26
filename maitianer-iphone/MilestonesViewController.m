//
//  MilestonesViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "MilestonesViewController.h"
#import "Milestone.h"
#import "Photo.h"
#import "Baby.h"
#import "NSDate-Utilities.h"
#import "EditingMilestoneViewController.h"
#import "MWPhotoBrowser.h"
#import "MTCaptionView.h"
#import "Utilities.h"

#define DETAIL_LABEL_TAG 1
#define DATE_LABEL_TAG 2
#define PHOTO_TAG 3

@interface MilestonesViewController () 
@property (nonatomic, retain) NSFetchedResultsController *fetchedMilestonesController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedPhotosController;
@end

@implementation MilestonesViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedMilestonesController = _fetchedMilestonesController;
@synthesize fetchedPhotosController = _fetchedPhotosController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"里程碑";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"milestones.png"] tag:3] autorelease];
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
    [_fetchedMilestonesController release];
    [_fetchedPhotosController release];
    [super dealloc];
}       

#pragma mark - Properties
- (NSFetchedResultsController *)fetchedMilestonesController {
    if (_fetchedMilestonesController) {
        return _fetchedMilestonesController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Milestone" inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO]]];
    
    _fetchedMilestonesController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    //_fetchedMilestonesController.delegate = self;
    
    [request release];
    
    return _fetchedMilestonesController;
}

- (NSFetchedResultsController *)fetchedPhotosController {
    if (_fetchedPhotosController) {
        return _fetchedPhotosController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES], nil]];
    
    _fetchedPhotosController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [request release];
    return _fetchedPhotosController;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //set table view appearence
    self.view.backgroundColor = RGBCOLOR(229, 234, 204);
    self.tableView.backgroundColor = RGBCOLOR(229, 234, 204);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //set editing button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSError *error;
    if (![self.fetchedMilestonesController performFetch:&error]) {
        //handler the error
    }
    
    [self.tableView reloadData];
    
    if ([self.fetchedMilestonesController.fetchedObjects count] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

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

#pragma mark - NSFetchedResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    switch (type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedMilestonesController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MilestoneCell";
    
    UIImageView *photoView;
    UILabel *detailLabel;
    UILabel *dateLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        UIView *detailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(85, 5, 225, 52)];
        detailBackgroundView.backgroundColor = RGBCOLOR(242, 244, 230);
        detailBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        detailBackgroundView.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:detailBackgroundView];
        [detailBackgroundView release];
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
        photoView.tag = PHOTO_TAG;
        [cell.contentView addSubview:photoView];
        photoView.layer.cornerRadius = 5;
        photoView.layer.masksToBounds = YES;
        [photoView release];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 220, 52)];
        detailLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        detailLabel.tag = DETAIL_LABEL_TAG;
        detailLabel.textColor = RGBCOLOR(175, 183, 147);
        detailLabel.numberOfLines = 2;
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:detailLabel];
        [detailLabel release];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 60, 170, 12)];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        dateLabel.tag = DATE_LABEL_TAG;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:dateLabel];
        [dateLabel release];
         
    }else {
        photoView = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        detailLabel = (UILabel *)[cell.contentView viewWithTag:DETAIL_LABEL_TAG];
        dateLabel = (UILabel *)[cell.contentView viewWithTag:DATE_LABEL_TAG];
    }
    
    // Configure the cell...
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Milestone *milestone = [self.fetchedMilestonesController objectAtIndexPath:indexPath];
    detailLabel.text = milestone.content;
    photoView.image = milestone.photo.b140Image;
    dateLabel.text = [NSString stringWithFormat:@"%d-%02d-%02d 出生%@", milestone.recordDate.year, milestone.recordDate.month, milestone.recordDate.day, [Utilities daysAfterBirthday:milestone.baby.birthday fromDate:milestone.recordDate]];
    
    return cell;
}

 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Milestone *milestone = [self.fetchedMilestonesController objectAtIndexPath:indexPath];
        [milestone.managedObjectContext deleteObject:milestone];
        NSError *error;
        if (![milestone.managedObjectContext save:&error]) {
            //handle the error
        }
        
        [self.fetchedMilestonesController performFetch:&error];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Milestone *milestone = [self.fetchedMilestonesController objectAtIndexPath:indexPath];
    if (self.editing) {
        EditingMilestoneViewController *editingMilestoneVC = [[EditingMilestoneViewController alloc] initWithNibName:@"EditingMilestoneViewController" bundle:[NSBundle mainBundle]];
        editingMilestoneVC.title = @"编辑里程碑";
        editingMilestoneVC.milestone = milestone;
        editingMilestoneVC.editing = YES;
        [self.navigationController pushViewController:editingMilestoneVC animated:YES];
        [editingMilestoneVC release];
    }else {
        NSError *error;
        [self.fetchedPhotosController performFetch:&error];
        if (error) {
            // Handle error
        }
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [self.navigationController pushViewController:photoBrowser animated:YES];
        photoBrowser.navigationController.navigationBarHidden = YES;
        [photoBrowser setInitialPageIndex:[self.fetchedPhotosController.fetchedObjects indexOfObject:milestone.photo]];
        [photoBrowser release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.fetchedPhotosController.fetchedObjects count];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.fetchedPhotosController.fetchedObjects objectAtIndex:index];
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    Photo *photo = [self.fetchedPhotosController.fetchedObjects objectAtIndex:index];
    if (photo.caption == nil) {
        return nil;
    }
    return [[MTCaptionView alloc] initWithPhoto:[self.fetchedPhotosController.fetchedObjects objectAtIndex:index]];
}

- (void)didFinishDeletePhotoInBrowser:(MWPhotoBrowser *)photoBrowser {
    NSError *error;
    [self.fetchedPhotosController performFetch:&error];
    if (error) {
        // Handle error
    }
    [photoBrowser reloadData];
}

@end
