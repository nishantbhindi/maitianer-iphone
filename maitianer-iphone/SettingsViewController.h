//
//  SettingsViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 12-1-1.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, WBEngineDelegate> {
    
    NSManagedObjectContext *_managedObjectContext;
    
    IBOutlet UITableView *_tableView;
    NSMutableDictionary *_settingsData;
    
    NSArray *_babies;
    
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *settingsData;
@property (nonatomic, retain) NSArray *babies;
@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;

- (IBAction)done:(id)sender;
- (void)shareSwitchValueChanged:(UISwitch *)sender;

@end
