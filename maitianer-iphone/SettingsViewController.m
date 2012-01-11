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

#define SINA_WEIBO_TAG 301

@implementation SettingsViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize tableView = _tableView;
@synthesize settingsData = _settingsData;
@synthesize babies = _babies;
@synthesize weibo = _weibo;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;

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
        
        cell.textLabel.text = [[self.settingsData objectForKey:sectionKey] objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上同步", nil];
        [loginAlertView addSubview:self.usernameTextField];
        [loginAlertView addSubview:self.passwordTextField];
        [loginAlertView show];
        [loginAlertView release];
    }
}

#pragma mark - Weibo session delegate
- (void)weiboDidLogin {
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"绑定成功" afterDelay:2];
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
        //
    }
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.usernameTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    }else if(self.passwordTextField == textField) {
        //send request
    }
    return YES;
}

@end
