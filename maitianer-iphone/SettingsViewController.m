//
//  SettingsViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 12-1-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "SettingsViewController.h"
#import "Baby.h"
#import "EditingBabyViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "FlurryAnalytics.h"
#import "Authorization.h"
#import "Utilities.h"

#define SINA_WEIBO_TAG 301

@implementation SettingsViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView = _tableView;
@synthesize settingsData = _settingsData;
@synthesize babies = _babies;

- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)shareSwitchValueChanged:(UISwitch *)sender {
    AppDelegate *appDelegate = [Utilities appDelegate];
    appDelegate.wbEngine.delegate = appDelegate;
    if (sender.tag == SINA_WEIBO_TAG) {
        if (sender.on) {
            if (![appDelegate.wbEngine isLoggedIn]) {
                [appDelegate.wbEngine logIn];
            }
        }else {
            if ([appDelegate.wbEngine isLoggedIn]) {
                [appDelegate.wbEngine logOut];
            }
        }
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
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
    self.babies = [Utilities fetchBabies];
    NSArray *sharesArray = [NSArray arrayWithObjects:@"绑定新浪微博", nil];
    self.settingsData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.babies, sharesArray, nil] 
                                                    forKeys:[NSArray arrayWithObjects:@"设置宝宝信息" ,@"分享设置" , nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            UISwitch *shareBindingSwitch = [[UISwitch alloc] init];
            AppDelegate *appDelegate = [Utilities appDelegate];
            if ([appDelegate.wbEngine isLoggedIn]) {
                shareBindingSwitch.on = YES;
            }else {
                shareBindingSwitch.on = NO;
            }
            [shareBindingSwitch addTarget:self action:@selector(shareSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            shareBindingSwitch.tag = SINA_WEIBO_TAG;
            cell.accessoryView = shareBindingSwitch;
            [shareBindingSwitch release];
        }
        
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *sectionKey = [[self.settingsData allKeys] objectAtIndex:section];

    return sectionKey;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionKey = [[self.settingsData allKeys] objectAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:@"设置宝宝信息"]) {
        Baby *baby = [self.babies objectAtIndex:indexPath.row];
        EditingBabyViewController *editingBabyVC = [[EditingBabyViewController alloc] initWithNibName:@"EditingBabyViewController" bundle:[NSBundle mainBundle]];
        editingBabyVC.baby = baby;
        [self.navigationController pushViewController:editingBabyVC animated:YES];
        [editingBabyVC release];
    }
}

@end
