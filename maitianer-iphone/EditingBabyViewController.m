//
//  EditingBabyViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "EditingBabyViewController.h"
#import "Baby.h"
#import "AppDelegate.h"


@implementation EditingBabyViewController
@synthesize nameField = _nameField;
@synthesize birthdayField = _birthdayField;
@synthesize sexField = _sexField;
@synthesize birthWeightField = _birthWeightField;
@synthesize fatherNameField = _fatherNameField;
@synthesize motherNameField = _motherNameField;

@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [_nameField release];
    [_birthdayField release];
    [_sexField release];
    [_birthWeightField release];
    [_fatherNameField release];
    [_motherNameField release];
    
    [_managedObjectContext release];
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
    
    Baby *baby = (Baby *)[NSEntityDescription insertNewObjectForEntityForName:@"Baby" inManagedObjectContext:self.managedObjectContext];
    baby.nickName = self.nameField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    baby.birthday  =[dateFormatter dateFromString:self.birthdayField.text];
    [dateFormatter release];
    
    if (self.sexField.text == @"小帅哥") {
        baby.sex = [NSNumber numberWithInt:1];
    }else if (self.sexField.text == @"小美女") {
        baby.sex = [NSNumber numberWithInt:2];
    }else {
        baby.sex = [NSNumber numberWithInt:0];
    }
    
    baby.fatherName = self.fatherNameField.text;
    
    baby.motherName = self.motherNameField.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //Handle the error
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)birthdayPickerChange:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayField.text = [dateFormatter stringFromDate:datePicker.date];
    [dateFormatter release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //don't allow select tableView cell
    self.tableView.allowsSelection = NO;
    
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
    [dateFormattor release];
    [birthdayPicker addTarget:self action:@selector(birthdayPickerChange:) forControlEvents:UIControlEventValueChanged];
    _birthdayField.inputView = birthdayPicker;
    [birthdayPicker release];
    
    _sexField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _sexField.delegate = self;
    _sexField.placeholder = @"可选";
    
    _birthWeightField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _birthWeightField.delegate = self;
    _birthWeightField.placeholder = @"可选";
    
    _fatherNameField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _fatherNameField.delegate = self;
    _fatherNameField.placeholder = @"如：麦麦他爸";
    
    _motherNameField = [[UITextField alloc] initWithFrame:incellFieldRect];
    _motherNameField.delegate = self;
    _motherNameField.placeholder = @"如：麦麦他妈";

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    return 2;
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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameField) {
        [self.birthdayField becomeFirstResponder];
    }
    
    return YES;
}

@end
