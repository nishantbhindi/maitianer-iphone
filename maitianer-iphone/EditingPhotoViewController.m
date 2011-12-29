//
//  EditingPhotoViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-30.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "EditingPhotoViewController.h"
#import "Photo.h"
#import "Milestone.h"
#import "AppDelegate.h"
#import "NSDate-Utilities.h"
#import "SVProgressHUD.h"

#define DELETE_ALERT_TAG 1
#define SHARE_ALERT_TAG 2

@implementation EditingPhotoViewController
@synthesize photoText = _photoText;
@synthesize imageView = _imageView;
@synthesize shareSwitch = _shareSwitch;
@synthesize photo = _photo;
@synthesize weibo = _weibo;

- (IBAction)shareSwitchValueChanged:(UISwitch *)sender {
    if (sender.on && ![self.photo.shared boolValue]) {
        if(!self.weibo.isUserLoggedin) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有绑定微博帐号，马上绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = SHARE_ALERT_TAG;
            [alertView show];
            [alertView release];
        }
    }
}

- (void)setPhoto:(Photo *)photo {
    if (_photo != photo) {
        [_photo release];
        _photo = [photo retain];
        
        self.photoText.text = [_photo.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.imageView.image = _photo.image;
        self.shareSwitch.on = [_photo.shared boolValue];
    }
}

- (void)cancelEditing {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveEditing {
    self.photo.content = self.photoText.text;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
    if (self.weibo.isUserLoggedin && ![self.photo.shared boolValue] && self.shareSwitch.on) {
        [self.weibo postWeiboRequestWithText:self.photo.content andImage:self.photo.image andDelegate:self];
    }else {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithSuccess:@"编辑成功"];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)removePhoto {
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除照片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    confirmAlert.tag = DELETE_ALERT_TAG;
    [confirmAlert show];
    [confirmAlert release];
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
    [_photoText release];
    [_imageView release];
    [_shareSwitch release];
    [_photo release];
    [_weibo release];
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
    
    self.view.backgroundColor = RGBCOLOR(229, 234, 204);
    //self.title = [NSString stringWithFormat:@"%d年%02d月%02d日", self.photo.recordDate.year, self.photo.recordDate.month, self.photo.recordDate.day];
    self.title = @"编辑照片";
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelEditing)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveEditing)];
    [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.weibo = appDelegate.weibo;
    self.weibo.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.photo) {
        self.photoText.text = self.photo.content;
        self.imageView.image = self.photo.image;
        self.shareSwitch.on = [self.photo.shared boolValue];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.photoText becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == DELETE_ALERT_TAG) {
        if (buttonIndex == 1) {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate.managedObjectContext deleteObject:self.photo];
            [appDelegate saveContext];
            [self dismissModalViewControllerAnimated:YES];
        }
    }else if (alertView.tag == SHARE_ALERT_TAG) {
        if (buttonIndex == 1) {
            [self.weibo startAuthorize];
        }
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
    self.shareSwitch.on = NO;
}

#pragma mark - Weibo request delegate
- (void)requestLoading:(WBRequest *)request {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient networkIndicator:YES];
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD dismissWithError:@"分享失败，请重试" afterDelay:1];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)request:(WBRequest *)request didLoad:(id)result {
    self.photo.shared = [NSNumber numberWithBool:YES];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    [SVProgressHUD dismissWithSuccess:@"保存，并分享成功" afterDelay:1];
    [self dismissModalViewControllerAnimated:YES];
}

@end
