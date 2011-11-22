//
//  CalendarViewController.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "CalendarViewController.h"
#import "EditingBabyViewController.h"
#import "NSDate-Utilities.h"

@implementation CalendarViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize baby = _baby;
@synthesize babyNameLabel = _babyNameLabel;
@synthesize daysFromBirthdayLabel = _daysFromBirthdayLabel;
@synthesize daysAfterRecord = _daysAfterRecord;

- (NSArray *)_fetchBabies {
    //fetch babies from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Baby"];
    NSError *error = nil;
    NSArray *babiesArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (babiesArray == nil) {
        //Handle the error.
    }
    NSLog(@"babies count: %d", [babiesArray count]);
    return babiesArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"日历";
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
    [_baby release];
    [_babyNameLabel release];
    [_daysFromBirthdayLabel release];
    [_daysAfterRecord release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *babiesArray = [self _fetchBabies];
    
    //show editing baby view controller for create a baby if baby not existed
    if ([babiesArray count] == 0) {
        EditingBabyViewController *editingBabyVC = [[EditingBabyViewController alloc] initWithStyle:UITableViewStyleGrouped];
        editingBabyVC.title = @"添加宝宝信息";
        editingBabyVC.managedObjectContext = self.managedObjectContext;
        UINavigationController *editingBabyNVC = [[UINavigationController alloc] initWithRootViewController:editingBabyVC];
        [self presentModalViewController:editingBabyNVC animated:YES];
        [editingBabyVC release];
        [editingBabyNVC release];
    }else {
        self.baby = [babiesArray objectAtIndex:0];
        self.babyNameLabel.text = self.baby.nickName;
        NSString *duringBirthday = nil;
        NSInteger yearsAfter = [[NSDate date] year] - [self.baby.birthday year];
        NSInteger monthsAfter = [[NSDate date] month] - [self.baby.birthday month];
        if (monthsAfter < 0) {
            yearsAfter = yearsAfter - 1;
            monthsAfter = 12 + monthsAfter;
        }
        if (yearsAfter > 0) {
            duringBirthday = [NSString stringWithFormat:@"%d年%d个月", yearsAfter, monthsAfter];
        }else {
            duringBirthday = [NSString stringWithFormat:@"%d天", [[NSDate date] daysAfterDate:self.baby.birthday]];
        }
        self.daysFromBirthdayLabel.text = [NSString stringWithFormat:@"宝宝出生到现在已经%@了", duringBirthday];
        self.daysAfterRecord.text = [NSString stringWithFormat:@"您已经有40天没有记录宝宝了"];
    }
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set baby and show baby info after create baby
    if (self.baby == nil) {
        NSArray *babiesArray = [self _fetchBabies];
        self.baby = [babiesArray objectAtIndex:0];
    }
}

@end
