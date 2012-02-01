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

#define SINA_WEIBO_TAG 301

@implementation SettingsViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView = _tableView;
@synthesize settingsData = _settingsData;
@synthesize babies = _babies;
@synthesize weibo = _weibo;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;

- (void)_validateLogin {
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.passwordTextField.text = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.usernameTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObject:
                                    [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.usernameTextField.text, self.passwordTextField.text, nil] 
                                                                forKeys:[NSArray arrayWithObjects:@"email", @"password", nil]] 
                                                               forKey:@"user"];
    NSString *userJson = [userDictionary JSONRepresentation];
    NSLog(@"User info: %@", userJson);
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/login"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[userJson dataUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    [request startAsynchronous];
}

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

- (UITextField *)usernameTextField {
    if (_usernameTextField) {
        return _usernameTextField;
    }
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 43, 260, 25)];
    _usernameTextField.placeholder = @"邮箱";
    _usernameTextField.backgroundColor = [UIColor whiteColor];
    _usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.delegate = self;
    
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField) {
        return _passwordTextField;
    }
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 72, 260, 25)];
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.returnKeyType = UIReturnKeySend;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    
    return _passwordTextField;
}

- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)shareSwitchValueChanged:(UISwitch *)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (sender.tag == SINA_WEIBO_TAG) {
        if (sender.on) {
            if (![appDelegate.weibo isUserLoggedin]) {
                [appDelegate.weibo startAuthorize];
            }
        }else {
            [appDelegate.weibo LogOut];
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
    [_weibo release];
    [_usernameTextField release];
    [_passwordTextField release];
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
    
    NSArray *sharesArray = [NSArray arrayWithObjects:@"绑定新浪微博", nil];
    NSArray *synButton = [NSArray arrayWithObjects:@"设置同步账号", nil];
    self.settingsData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.babies, synButton, sharesArray, nil] 
                                                    forKeys:[NSArray arrayWithObjects:@"设置宝宝信息", @"数据同步" ,@"分享设置" , nil]];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.weibo = appDelegate.weibo;
    self.weibo.delegate = self;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            UISwitch *shareBindingSwitch = [[UISwitch alloc] init];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([appDelegate.weibo isUserLoggedin]) {
                shareBindingSwitch.on = YES;
            }else {
                shareBindingSwitch.on = NO;
            }
            [shareBindingSwitch addTarget:self action:@selector(shareSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            shareBindingSwitch.tag = SINA_WEIBO_TAG;
            cell.accessoryView = shareBindingSwitch;
            [shareBindingSwitch release];
        }
        
    }else if ([sectionKey isEqualToString:@"数据同步"]){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSyn];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSyn];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"authenticated"] boolValue]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-马上同步", [[NSUserDefaults standardUserDefaults] stringForKey:@"email"]];
        }else {
            cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
            
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *sectionKey = [[self.settingsData allKeys] objectAtIndex:section];
    if ([sectionKey isEqualToString:@"数据同步"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]) {
            NSDate *lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"];
            NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            return [NSString stringWithFormat:@"最后同步时间: %@", [dateFormater stringFromDate:lastSyncDate]];
        }else {
            return nil;
        }
    }
    return nil;
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
    }else if ([sectionKey isEqualToString:@"分享设置"]) {
        
    }else if ([sectionKey isEqualToString:@"数据同步"]) {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"authenticated"] boolValue]) {
            [SVProgressHUD showWithStatus:@"开始同步，显示同步界面"];
            
            NSDate *lastSyncDate = nil;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"]) {
                lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"];
            }
            lastSyncDate = nil;
            NSError *error;
            //sync babies
            NSFetchRequest *babiesFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Baby"];
            NSArray *babiesArray = [self.managedObjectContext executeFetchRequest:babiesFetchRequest error:&error];
            NSLog(@"sync babies json: %@", [babiesArray JSONRepresentation]);
            [babiesFetchRequest release];
            //sync photos
            NSFetchRequest *photosFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
            if (lastSyncDate) {
                [photosFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(lastModifiedByDate > %@) AND (creationDate > %@)", lastSyncDate, lastSyncDate]];
            }
            [photosFetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastModifiedByDate" ascending:YES]]];
            NSArray *photosArray = [self.managedObjectContext executeFetchRequest:photosFetchRequest error:&error];
            NSDictionary *photosDict = [NSDictionary dictionaryWithObject:photosArray forKey:@"photos"];
            NSLog(@"sync photos json: %@", [photosDict JSONRepresentation]);
            [photosFetchRequest release];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/sync/sync_photos"]];
            request.requestMethod = @"POST";
            [request addRequestHeader:@"Accept" value:@"application/json"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request appendPostData:[[photosDict JSONRepresentation] dataUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
            [request startAsynchronous];
            //sync milestone
            NSFetchRequest *milestoneFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Milestone"];
            if (lastSyncDate) {
                [photosFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(lastModifiedByDate > %@) AND (creationDate > %@)", lastSyncDate, lastSyncDate]];
            }
            [milestoneFetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastModifiedByDate" ascending:YES]]];
            NSArray *milestonesArray = [self.managedObjectContext executeFetchRequest:milestoneFetchRequest error:&error];
            NSLog(@"sync milestones json: %@", [milestonesArray JSONRepresentation]);
            [milestoneFetchRequest release];
            //sync end
            lastSyncDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:lastSyncDate forKey:@"lastSyncDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SVProgressHUD dismiss];
            
        }else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上同步", nil];
            [loginAlertView addSubview:self.usernameTextField];
            [loginAlertView addSubview:self.passwordTextField];
            [loginAlertView show];
            [loginAlertView release];
        }
    }
}

#pragma mark - Weibo session delegate
- (void)weiboDidLogin {
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"绑定成功" afterDelay:2];
    [FlurryAnalytics logEvent:@"BindedSinaWeibo"];
}

- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError *)error {
    NSLog(@"帐号绑定失败！错误信息：%@", [error description]);
    [SVProgressHUD show];
    [SVProgressHUD dismissWithError:userCancelled?@"用户取消":@"绑定失败" afterDelay:2];
    UISwitch *shareSwitch = (UISwitch *)[self.view viewWithTag:SINA_WEIBO_TAG];
    shareSwitch.on = NO;
}

#pragma mark - Alert view delegate
- (void)willPresentAlertView:(UIAlertView *)alertView {
    [self.usernameTextField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self _validateLogin];
    }
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.usernameTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    }else if(self.passwordTextField == textField) {
        [self _validateLogin];
    }
    return YES;
}

#pragma mark - ASI request delegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *returnJson = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnJson);
    NSDictionary *returnDict = [returnJson JSONValue];
    if (request.responseStatusCode == 200 || request.responseStatusCode == 201) {
        NSLog(@"email: %@", [returnDict objectForKey:@"email"]);
        [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"authenticated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }else {
        [self requestFailed:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"failed with error: %d %@", [request responseStatusCode], [request.error localizedDescription]);
    
    if (request.responseStatusCode == 401) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
}

@end
