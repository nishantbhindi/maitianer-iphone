//
//  LoginViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, JSONRequestDelegate> {
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    UISwitch *_rememberMeSwitch;
    UIButton *_loginButton;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMeSwitch;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonPress:(id)sender;

@end
