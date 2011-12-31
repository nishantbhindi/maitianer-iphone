//
//  EditingBabyViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Baby;

@interface EditingBabyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    Baby *_baby;
    
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_promptLabel;
    IBOutlet UIButton *_detailInfoButton;
    
    UITextField *_nameField;
    UITextField *_birthdayField;
    UITextField *_sexField;
    UITextField *_birthWeightField;
    UITextField *_fatherNameField;
    UITextField *_motherNameField;
    
    NSArray *_sexArray;
}

@property (nonatomic, retain) Baby *baby;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UILabel *promptLabel;
@property (nonatomic, retain) UIButton *detailInfoButton;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *birthdayField;
@property (nonatomic, retain) UITextField *sexField;
@property (nonatomic, retain) UITextField *birthWeightField;
@property (nonatomic, retain) UITextField *fatherNameField;
@property (nonatomic, retain) UITextField *motherNameField;

- (void)saveBaby;
- (void)birthdayPickerChange:(UIDatePicker *)datePicker;
- (IBAction)toggleDetailInfo:(UIButton *)sender;

@end
