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
#import "PhotographViewController.h"
#import "PhotosViewController.h"

@implementation CalendarViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize photoResultsController = _photoResultsController;
@synthesize baby = _baby;
@synthesize photographVC = _photographVC;
@synthesize babyInfoView = _babyInfoView;
@synthesize avatarView = _avatarView;
@synthesize babyNameLabel = _babyNameLabel;
@synthesize daysFromBirthdayLabel = _daysFromBirthdayLabel;
@synthesize daysAfterRecordLabel = _daysAfterRecordLabel;
@synthesize babyInfoToggle = _babyInfoToggle;
@synthesize calendarView = _calendarView;

- (IBAction)toggleBabyInfo:(id)sender {
    UIButton *button = sender;
    CGRect babyInfoFrame = self.babyInfoView.frame;
    CGRect buttonFrame = button.frame;
    CGRect calendarViewFrame = self.calendarView.frame;
    [UIView beginAnimations:@"Baby Info Move in/out" context:nil];
    if (babyInfoFrame.origin.y >= 0) {
        babyInfoFrame.origin.y = -babyInfoFrame.size.height;
        buttonFrame.origin.y -= babyInfoFrame.size.height;
        [button setTitle:@"打开" forState:UIControlStateNormal];
        calendarViewFrame.size.height += babyInfoFrame.size.height;
        calendarViewFrame.origin.y -= babyInfoFrame.size.height;
    }else {
        babyInfoFrame.origin.y = 0;
        buttonFrame.origin.y += babyInfoFrame.size.height;
        [button setTitle:@"收起" forState:UIControlStateNormal];
        calendarViewFrame.size.height -= babyInfoFrame.size.height;
        calendarViewFrame.origin.y += babyInfoFrame.size.height;
    }
    self.babyInfoView.frame = babyInfoFrame;
    button.frame = buttonFrame;
    self.calendarView.frame = calendarViewFrame;
    [UIView commitAnimations];
}

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

- (void)_showPhotosInCalendar {
    
    //fetch result sections
    NSArray *sectionsArray = [self.photoResultsController sections];
    
    //fill in calendar cell by record date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (id <NSFetchedResultsSectionInfo> sectionInfo in sectionsArray) {
        NSDate *sectionDate = [dateFormatter dateFromString:sectionInfo.name];
        MTCalendarCellView *cell = [self.calendarView cellForDate:sectionDate];
        if (cell) {
            cell.photos = [sectionInfo objects];
        }
    }
    [dateFormatter release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"日历";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"日历" image:[UIImage imageNamed:@"calendar.png"] tag:1] autorelease];
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
    [_photoResultsController release];
    [_baby release];
    [_photographVC release];
    [_babyInfoView release];
    [_avatarView release];
    [_babyNameLabel release];
    [_daysFromBirthdayLabel release];
    [_daysAfterRecordLabel release];
    [_babyInfoToggle release]; 
    [_calendarView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *babiesArray = [self _fetchBabies];
    
    //init photos fetched results controller
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    _photoResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"recordDateLabel" cacheName:nil];
    
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
    }
    
    //config calendar view
    self.calendarView.delegate = self;
    self.calendarView.miniumDate = self.baby.birthday;
    
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
    
    self.navigationController.navigationBarHidden = YES;
    
    //set baby and show baby info after create baby
    if (self.baby == nil) {
        NSArray *babiesArray = [self _fetchBabies];
        self.baby = [babiesArray objectAtIndex:0];
    }
    
    //fetch photos per day from database
    NSError *error = nil;
    BOOL success = [self.photoResultsController performFetch:&error];
    if (error != nil || !success) {
        //handle the error.
    }
    
    //config baby info
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
    self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您已经有40天没有记录宝宝了"];
    
    //fetch photos then show in calendar
    [self _showPhotosInCalendar];
    
}

#pragma mark - calendar view delegate methods
- (void)calendarView:(MTCalendarView *)calendarView didSelectDate:(NSDate *)date {
    MTCalendarCellView *cell = [calendarView cellForDate:date];
    if (cell.photos) {
        //show photos at selected date
        PhotosViewController *photosVC = [[PhotosViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //set controller title
        NSDateFormatter *dateFormattor = [[NSDateFormatter alloc] init];
        dateFormattor.dateFormat = @"yyyy年MM月dd日";
        photosVC.title = [dateFormattor stringFromDate:date];
        [dateFormattor release];
        
        //set controller photos
        photosVC.photos = cell.photos;
        
        //set managed object context
        photosVC.managedObjectContext = self.managedObjectContext;
        
        [self.navigationController pushViewController:photosVC animated:YES];
        [photosVC release];
    }else {
        //show photos library for picking photo
        self.photographVC.recordDate = date;
        [self.photographVC photoLibraryAction:[calendarView cellForDate:date]];
    }
    
}

- (void)monthDidChangeOnCalendarview:(MTCalendarView *)calendarView {
    [self _showPhotosInCalendar];
}

@end
