//
//  SettingsViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 12-1-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "SettingsViewController.h"
#import "Baby.h"

@implementation SettingsViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView = _tableView;
@synthesize settingsData = _settingsData;
@synthesize babies = _babies;

- (NSArray *)babies {
    if (_babies) {
        return _babies;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Baby"];
    NSError *error;
    _babies = [[self.managedObjectContext executeFetchRequest:request error:&error] retain];
    if (error) {
        //handle the error
    }
    return _babies;
}

- (IBAction)done:(id)sender {
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
    [_managedObjectContext release];
    [_tableView release];
    [_settingsData release];
    [_babies release];
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
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
    
    NSArray *sharesArray = [NSArray arrayWithObjects:@"绑定新浪微博", @"绑定腾讯微博", nil];
    NSArray *synButton = [NSArray arrayWithObjects:@"设置同步账号", nil];
    self.settingsData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.babies, sharesArray, synButton, nil] 
                                                    forKeys:[NSArray arrayWithObjects:@"设置宝宝信息", @"分享设置", @"数据同步账号", nil]];
    
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

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settingsData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.settingsData allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.settingsData allValues] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifierBaby = @"SettingBabyCell";
    static NSString *CellIdentifierShare = @"SettingShareCell";
    static NSString *CellIdentifierSyn = @"SettingSynCell";
    
    UITableViewCell *cell;
    
    NSString *sectionKey = [[self.settingsData allKeys] objectAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:@"设置宝宝信息"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierBaby];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierBaby];
        }
        
        Baby *baby = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        cell.textLabel.text = baby.nickName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([sectionKey isEqualToString:@"分享设置"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierShare];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierShare];
        }
        
        cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        cell.accessoryView = [[[UISwitch alloc] init] autorelease];
    }else if ([sectionKey isEqualToString:@"数据同步账号"]){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSyn];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSyn];
        }
        
        cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

#pragma mark - Table view delegate

@end
