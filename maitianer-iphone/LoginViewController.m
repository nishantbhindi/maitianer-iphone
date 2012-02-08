//
//  LoginViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "JSONRequest.h"

@implementation LoginViewController
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize rememberMeSwitch = _rememberMeSwitch;
@synthesize loginButton = _loginButton;

- (IBAction)loginButtonPress:(id)sender {
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.passwordTextField.text = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
    
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjects:
                                     [NSArray arrayWithObjects:self.usernameTextField.text, self.passwordTextField.text, nil] 
                                                                forKeys:[NSArray arrayWithObjects:@"user[email]", @"user[password]", nil]];
    
    [[[JSONRequest alloc] initPostWithPath:@"/login.json" parameters:userDictionary delegate:self] autorelease];
    
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
    [_usernameTextField release];
    [_passwordTextField release];
    [_rememberMeSwitch release];
    [_loginButton release];
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

#pragma mark - JSONRequest delegate 
- (void)jsonDidFinishLoading:(NSDictionary *)json jsonRequest:(JSONRequest *)request {
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    if ([[json valueForKey:@"email"] length]) {
        NSLog(@"email: %@", [json objectForKey:@"email"]);
        //save cookie for other request
        
        //save email
        [[NSUserDefaults standardUserDefaults] setValue:[json objectForKey:@"email"] forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD dismissWithSuccess:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalendarView" object:nil];
    }else if ([[json valueForKey:@"error"] length]) {
        NSLog(@"result json error message: %@", [json valueForKey:@"error"]);
    }
}

- (void)jsonDidFailWithError:(NSError *)error jsonRequest:(JSONRequest *)request {
    NSLog(@"failed with error: %d %@", [request.response statusCode], [error localizedDescription]);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    if ([request.response statusCode] == 401) {
        [SVProgressHUD dismissWithError:@"用户名或密码错误"];
    }else {
        [SVProgressHUD dismissWithError:@"请检查网络连接"];
    }
}

@end
