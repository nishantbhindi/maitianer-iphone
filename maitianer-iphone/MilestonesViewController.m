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
#import "AppDelegate.h"
#import "NSDate-Utilities.h"
#import "EditingMilestoneViewController.h"
#import "PhotosViewController.h"

#define DETAIL_LABEL_TAG 1
#define DATE_LABEL_TAG 2
#define PHOTO_TAG 3

@implementation MilestonesViewController

@synthesize milestones = _milestones;

- (NSArray *)_fetchMilestones {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Milestone"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO]]];
    NSError *error = nil;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSArray *milestonesArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        //Handle the error
    }
    return milestonesArray;
}

- (NSString *)iconImageName {
	return @"magnifying-glass.png";
}

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
    [_milestones release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set navigation bar background image for ios 5
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    }
    
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
    _milestones = [[self _fetchMilestones] mutableCopy];
    [self.tableView reloadData];
    
    if ([self.milestones count] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    //show button
    UIView *button = [self.tabBarController.view viewWithTag:9999];
    [button setHidden:NO];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.milestones count];
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
    
    Milestone *milestone = [self.milestones objectAtIndex:indexPath.row];
    detailLabel.text = milestone.content;
    photoView.image = milestone.photo.b200Image;
    dateLabel.text = [NSString stringWithFormat:@"%d-%02d-%02d", milestone.recordDate.year, milestone.recordDate.month, milestone.recordDate.day];
    
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


 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        Milestone *milestone = [self.milestones objectAtIndex:indexPath.row];
        [appDelegate.managedObjectContext deleteObject:milestone];
        [appDelegate saveContext];
        [self.milestones removeObject:milestone];
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Milestone *milestone = [self.milestones objectAtIndex:indexPath.row];
    if (self.editing) {
        EditingMilestoneViewController *editingMilestoneVC = [[EditingMilestoneViewController alloc] initWithNibName:@"EditingMilestoneViewController" bundle:[NSBundle mainBundle]];
        editingMilestoneVC.title = @"编辑里程碑";
        editingMilestoneVC.milestone = milestone;
        editingMilestoneVC.editing = YES;
        [self.navigationController pushViewController:editingMilestoneVC animated:YES];
        [editingMilestoneVC release];
    }else {
        PhotosViewController *photosVC = [[PhotosViewController alloc] initWithStyle:UITableViewStylePlain];
        photosVC.recordDate = milestone.recordDate;
        [self.navigationController pushViewController:photosVC animated:YES];
        [photosVC release];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
