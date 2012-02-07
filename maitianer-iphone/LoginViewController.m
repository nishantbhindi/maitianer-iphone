//
//  LoginViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "SVProgressHUD.h"

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
    
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObject:
                                    [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.usernameTextField.text, self.passwordTextField.text, nil] 
                                                                forKeys:[NSArray arrayWithObjects:@"email", @"password", nil]] 
                                                               forKey:@"user"];
    
    NSString *userJson = [userDictionary JSONRepresentation];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/login"]];
    request.delegate = self;
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[userJson dataUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    [request startSynchronous];
    
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

#pragma mark - ASIHttpRequest delegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    [SVProgressHUD show];
    [self.loginButton setTitle:@"登录中..." forState:UIControlStateNormal];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    NSString *returnJson = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnJson);
    NSDictionary *returnDict = [returnJson JSONValue];
    if ([[returnDict valueForKey:@"email"] length]) {
        NSLog(@"email: %@", [returnDict objectForKey:@"email"]);
        [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"authenticated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD dismissWithSuccess:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCalendarView" object:nil];
    }else {
        [self requestFailed:request];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"failed with error: %d %@", [request responseStatusCode], [request.error localizedDescription]);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    if (request.responseStatusCode == 401) {
        [SVProgressHUD dismissWithError:@"用户名或密码错误"];
    }else {
        [SVProgressHUD dismissWithError:@"请检查网络连接"];
    }
    
}

@end
