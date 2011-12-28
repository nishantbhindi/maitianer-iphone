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
#import "AppDelegate.h"

@implementation CalendarViewController
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

- (NSString *)iconImageName {
	return @"magnifying-glass.png";
}

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //fetch babies from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Baby"];
    NSError *error = nil;
    NSArray *babiesArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (babiesArray == nil) {
        //Handle the error.
    }
    NSLog(@"babies count: %d", [babiesArray count]);
    return babiesArray;
}

- (Photo *)_fetchLatelyPhoto {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //fetch photos from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO]];
    request.fetchLimit = 1;
    NSError *error = nil;
    NSArray *photosArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (photosArray == nil || [photosArray count] == 0) {
        return nil;
    }
    return [photosArray objectAtIndex:0];
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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //init photos fetched results controller
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:appDelegate.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO], nil]];
    _photoResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:@"recordDateLabel" cacheName:nil];
    
    //show editing baby view controller for create a baby if baby not existed
    if ([babiesArray count] == 0) {
        EditingBabyViewController *editingBabyVC = [[EditingBabyViewController alloc] initWithNibName:@"EditingBabyViewController" bundle:[NSBundle mainBundle]];
        editingBabyVC.title = @"添加宝宝信息";
        UINavigationController *editingBabyNVC = [[UINavigationController alloc] initWithRootViewController:editingBabyVC];
        [self presentModalViewController:editingBabyNVC animated:YES];
        [editingBabyVC release];
        [editingBabyNVC release];
    }else {
        self.baby = [babiesArray objectAtIndex:0];
    }
    
    //config calendar view
    self.calendarView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *button = [self.tabBarController.view viewWithTag:9999];
    [button setHidden:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    //set baby and show baby info after create baby
    if (self.baby == nil) {
        NSArray *babiesArray = [self _fetchBabies];
        self.baby = [babiesArray objectAtIndex:0];
    }
    self.calendarView.miniumDate = self.baby.birthday;
    
    //fetch photos per day from database
    NSError *error = nil;
    BOOL success = [self.photoResultsController performFetch:&error];
    if (error != nil || !success) {
        //handle the error.
    }
    
    //fetch lately photo
    Photo *latelyPhoto = [self _fetchLatelyPhoto];
    
    if (latelyPhoto == nil) {
        _firstShow = [[UIButton alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_firstShow];
        [_firstShow setBackgroundImage:[UIImage imageNamed:@"first-show.jpg"] forState:UIControlStateNormal];
        [_firstShow addTarget:_firstShow action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [_firstShow release];
    }
    
    //config avatar shadow
    [self.avatarView.layer setCornerRadius:5];
    [self.avatarView.layer setShadowOffset:CGSizeMake(0, 1.0)];
    [self.avatarView.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.avatarView.layer setShadowRadius:0];
    [self.avatarView.layer setShadowOpacity:0.8];
    if (latelyPhoto) {
        //add real avatar for masks to bounds
        UIImageView *innerImageView = [[UIImageView alloc] initWithImage:latelyPhoto.image];
        innerImageView.layer.cornerRadius = 5;
        innerImageView.layer.masksToBounds = YES;
        innerImageView.frame = self.avatarView.bounds;
        [self.avatarView addSubview:innerImageView];
        [innerImageView release];
        
        int days = [latelyPhoto.creationDate daysAfterDate:[NSDate date]];
        if (days > 0) {
            self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您已经有%d天没有记录宝宝了", days];
        }else {
            self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您刚刚记录过"];
        }
        
    }else {
        self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您还没有开始记录"];
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
    self.daysFromBirthdayLabel.text = [NSString stringWithFormat:@"出生%@", duringBirthday];
    
    //reload calendar view for reset calendar cell view
    [self.calendarView reload];
    //fetch photos then show in calendar
    [self _showPhotosInCalendar];
    
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
        //photosVC.photos = [cell.photos mutableCopy];
        photosVC.recordDate = date;
        
        self.photographVC.recordDate = date;
        photosVC.photographVC = self.photographVC;
        
        //config back bar button item style
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
        [backBarButtonItem release];
        
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
