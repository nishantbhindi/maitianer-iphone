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

- (NSArray *)_fetchPhotosPerDay {
    //fetch photos per day from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    NSError *error = nil;
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"recordDateLabel" cacheName:nil];
    
    [fetchedResultsController performFetch:&error];
    NSArray *photosArray = [fetchedResultsController fetchedObjects];
    id <NSFetchedResultsSectionInfo> section = [[fetchedResultsController sections] objectAtIndex:0];
    NSLog(@"photos count: %d", [photosArray count]);
    NSLog(@"section title: %@", [section name]);
    NSLog(@"section objects count: %d", [section numberOfObjects]);
    [fetchedResultsController release];
    if (photosArray == nil) {
        //Handle the error.
    }
    
    return photosArray;
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
    [_baby release];
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
    [self _fetchPhotosPerDay];
    
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
        self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您已经有40天没有记录宝宝了"];
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
    
    //set baby and show baby info after create baby
    if (self.baby == nil) {
        NSArray *babiesArray = [self _fetchBabies];
        self.baby = [babiesArray objectAtIndex:0];
    }
}

#pragma mark - calendar view delegate methods
- (void)calendarView:(MTCalendarView *)calendarView didSelectDate:(NSDate *)date {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:[date descriptionWithLocale:[NSLocale systemLocale]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end
