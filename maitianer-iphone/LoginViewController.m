//
//  LoginViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize rememberMeSwitch;
@synthesize loginButton;

- (IBAction)login:(id)sender {
    if (self.usernameTextField == nil || [@"" isEqualToString:self.usernameTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"账号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.usernameTextField becomeFirstResponder];
        return;
    }
    
    if (self.passwordTextField == nil || [@"" isEqualToString:self.passwordTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    
    BOOL rememberMe = self.rememberMeSwitch.on;
    
    if (rememberMe) {
        //
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
    [usernameTextField release];
    [passwordTextField release];
    [rememberMeSwitch release];
    [loginButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户登录";
    [self.usernameTextField becomeFirstResponder];
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

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.usernameTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    }else if (self.passwordTextField == textField) {
        
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
