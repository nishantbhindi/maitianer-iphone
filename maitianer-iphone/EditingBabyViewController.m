//
//  EditingBabyViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "EditingBabyViewController.h"
#import "Baby.h"
#import "FlurryAnalytics.h"
#import "Utilities.h"

@implementation EditingBabyViewController
@synthesize baby = _baby;
@synthesize tableView = _tableView;
@synthesize promptLabel = _promptLabel;
@synthesize detailInfoButton = _detailInfoButton;
@synthesize nameField = _nameField;
@synthesize birthdayField = _birthdayField;
@synthesize sexField = _sexField;
@synthesize birthWeightField = _birthWeightField;
@synthesize fatherNameField = _fatherNameField;
@synthesize motherNameField = _motherNameField;

- (void)_keyboardWillShow:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    // we don't use SDK constants here to be universally compatible with all SDKs ≥ 3.0
    NSValue* keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    if (!keyboardFrameValue) {
        keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    }
    
    CGFloat keyboardHeight = [keyboardFrameValue CGRectValue].size.height;

    CGRect frame = self.view.frame;
    frame.size.height -= keyboardHeight;
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.tableView.frame = frame;
    [UIView commitAnimations];
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    NSLog(@"hide");
}

- (void)toggleDetailInfo:(UIButton *)sender {
    if (sender.selected) {
        self.promptLabel.hidden = NO;
        sender.selected = NO;
        [self.tableView reloadData];
    }else {
        self.promptLabel.hidden = YES;
        sender.selected = YES;
        [self.tableView reloadData];
    }
    
    [UIView beginAnimations:@"up/down detail info" context:nil];
    //resize table view and layout button
    CGRect tableFrame =  self.tableView.frame;
    tableFrame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = tableFrame;
    CGRect buttonFrame = self.detailInfoButton.frame;
    buttonFrame.origin.y = tableFrame.size.height;
    self.detailInfoButton.frame = buttonFrame;
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑宝宝信息";
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
    [_baby release];
    [_tableView release];
    [_promptLabel release];
    [_detailInfoButton release];
    [_nameField release];
    [_birthdayField release];
    [_sexField release];
    [_birthWeightField release];
    [_fatherNameField release];
    [_motherNameField release];

    [_sexArray release];
    [super dealloc];
}

- (void)saveBaby {
    
    if ([[self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.nameField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入宝宝名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.nameField becomeFirstResponder];
        return;
    }
    
    if ([[self.birthdayField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || self.birthdayField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入宝宝生日" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [self.birthdayField becomeFirstResponder];
        return;
    }
    
    self.baby.nickName = self.nameField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.baby.birthday  =[dateFormatter dateFromString:self.birthdayField.text];
    [dateFormatter release];
    
    if (self.sexField.text == @"小帅哥") {
        self.baby.sex = [NSNumber numberWithInt:1];
    }else if (self.sexField.text == @"小美女") {
        self.baby.sex = [NSNumber numberWithInt:2];
    }else {
        self.baby.sex = [NSNumber numberWithInt:0];
    }
    
    self.baby.fatherName = self.fatherNameField.text;
    self.baby.motherName = self.motherNameField.text;
    self.baby.lastModifiedByDate = [NSDate date];
    NSError *error;
    if (![self.baby.managedObjectContext save:&error]) {
        //handle the error
    }
    
    [FlurryAnalytics setUserID:self.baby.nickName];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)birthdayPickerChange:(UIDatePicker *)datePicker {
    self.birthdayField.text = [Utilities stringFromDate:datePicker.date withFormat:@"yyyy-MM-dd"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //don't allow select tableView cell
    self.tableView.allowsSelection = NO;
    
    //set table view background
    self.tableView.backgroundColor = RGBCOLOR(229, 233, 206);
    
    //right bar button item for save baby info
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBaby)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    
    //init baby fields
    CGRect incellFieldRect = CGRectMake(100, 12, 200, 23);
    _nameField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _nameField.delegate = self;
    _nameField.placeholder = @"必填，如：小妮子";
    _nameField.returnKeyType = UIReturnKeyNext;
    _nameField.text = self.baby.nickName;
    
    _birthdayField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _birthdayField.delegate = self;
    _birthdayField.placeholder = @"必填";
    //init birthday date picker
    UIDatePicker *birthdayPicker = [[UIDatePicker alloc] init];
    birthdayPicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
    dateFormattor.dateFormat = @"yyyy-MM-dd";
    birthdayPicker.minimumDate = [dateFormattor dateFromString:@"2005-01-01"];
    birthdayPicker.maximumDate = [NSDate date];
    _birthdayField.text = [dateFormattor stringFromDate:self.baby.birthday];
    [dateFormattor release];
    [birthdayPicker addTarget:self action:@selector(birthdayPickerChange:) forControlEvents:UIControlEventValueChanged];
    _birthdayField.inputView = birthdayPicker;
    [birthdayPicker release];
    
    _sexField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _sexField.delegate = self;
    _sexField.placeholder = @"可选";
    //init baby sex picker
    UIPickerView *sexPicker = [[UIPickerView alloc] init];
    sexPicker.dataSource = self;
    sexPicker.delegate = self;
    sexPicker.showsSelectionIndicator = YES;
    _sexField.inputView = sexPicker;
    [sexPicker release];
    
    
    _birthWeightField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _birthWeightField.delegate = self;
    _birthWeightField.placeholder = @"可选";
    
    _fatherNameField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _fatherNameField.delegate = self;
    _fatherNameField.placeholder = @"如：麦麦他爸";
    
    _motherNameField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _motherNameField.delegate = self;
    _motherNameField.placeholder = @"如：麦麦他妈";

    _sexArray = [[NSArray arrayWithObjects:@"小帅哥", @"小美女", @"保密", nil] retain];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.detailInfoButton.selected) {
        return 2;
    }else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 4;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"基本信息";
    }else if (section == 1) {
        return @"详细信息";
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"unreuseFieldCell"] autorelease];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [cell addSubview:self.nameField];
        }
        if (indexPath.row == 1) {
                        
            [cell addSubview:self.birthdayField];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            [cell addSubview:self.sexField];
        }
        if (indexPath.row == 1) {
            
            [cell addSubview:self.birthWeightField];
        }
        if (indexPath.row == 2) {
            
            [cell addSubview:self.fatherNameField];
        }
        if (indexPath.row == 3) {
            
            [cell addSubview:self.motherNameField];
        }
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"宝宝名称";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"宝宝生日";
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"出生体重";
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"父亲名称";
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"母亲名称";
        }
    }
    
    //custom text label appearance
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = RGBCOLOR(172, 175, 155);
    
    return cell;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    sectionTitleLabel.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        sectionTitleLabel.text = @"基本信息";
    }else {
        sectionTitleLabel.text = @"详细信息";
    }
    sectionTitleLabel.textAlignment = UITextAlignmentCenter;
    sectionTitleLabel.textColor = RGBCOLOR(61, 82, 36);
    sectionTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    return [sectionTitleLabel autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameField) {
        [self.birthdayField becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - Picker view datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_sexArray count];
}

#pragma mark - Picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_sexArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.sexField.text = [_sexArray objectAtIndex:row];
}

@end
