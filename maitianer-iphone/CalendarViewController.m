//
//  CalendarViewController.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "CalendarViewController.h"
#import "EditingBabyViewController.h"
#import "Utilities.h"
#import "SettingsViewController.h"
#import "MWPhoto.h"
#import "Milestone.h"
#import "FTAnimation.h"
#import "MTCaptionView.h"

#define FIRST_SHOW_BUTTON_TAG 100

@implementation CalendarViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize photoResultsController = _photoResultsController;
@synthesize baby = _baby;
@synthesize babyInfoView = _babyInfoView;
@synthesize avatarView = _avatarView;
@synthesize babyNameLabel = _babyNameLabel;
@synthesize daysFromBirthdayLabel = _daysFromBirthdayLabel;
@synthesize daysAfterRecordLabel = _daysAfterRecordLabel;
@synthesize babyInfoToggle = _babyInfoToggle;
@synthesize calendarView = _calendarView;
@synthesize photoPickerController = _photoPickerController;

- (IBAction)showSettings:(id)sender {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    settingsVC.title = @"设置";
    settingsVC.managedObjectContext = self.managedObjectContext;
    UINavigationController *settingsNVC = [[[UINavigationController alloc] initWithRootViewController:settingsVC] autorelease];
    [settingsVC release];
    settingsNVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:settingsNVC animated:YES];
}

- (IBAction)toggleBabyInfo:(id)sender {
    //UIButton *button = sender;
    CGRect babyInfoFrame = self.babyInfoView.frame;
    //CGRect buttonFrame = button.frame;
    CGRect calendarViewFrame = self.calendarView.frame;
    [UIView beginAnimations:@"Baby Info Move in/out" context:nil];
    if (babyInfoFrame.origin.y >= 0) {
        babyInfoFrame.origin.y = -babyInfoFrame.size.height;
        //buttonFrame.origin.y -= babyInfoFrame.size.height;
        //[button setTitle:@"打开" forState:UIControlStateNormal];
        calendarViewFrame.size.height += babyInfoFrame.size.height;
        calendarViewFrame.origin.y -= babyInfoFrame.size.height;
    }else {
        babyInfoFrame.origin.y = 0;
        //buttonFrame.origin.y += babyInfoFrame.size.height;
        //[button setTitle:@"收起" forState:UIControlStateNormal];
        calendarViewFrame.size.height -= babyInfoFrame.size.height;
        calendarViewFrame.origin.y += babyInfoFrame.size.height;
    }
    self.babyInfoView.frame = babyInfoFrame;
    //button.frame = buttonFrame;
    self.calendarView.frame = calendarViewFrame;
    [UIView commitAnimations];
}

- (Baby *)baby {
    if (_baby) {
        return _baby;
    }

    NSArray *babiesArray = [Utilities fetchBabies];

    if ([babiesArray count] > 0) {
        _baby = [[babiesArray objectAtIndex:0] retain];
    }
    return _baby;
}

- (Photo *)_fetchLatelyPhoto {
    //fetch photos from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO], nil];
    request.fetchLimit = 1;
    NSError *error = nil;
    NSArray *photosArray = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    [_managedObjectContext release];
    [_photoResultsController release];
    [_baby release];
    [_babyInfoView release];
    [_avatarView release];
    [_babyNameLabel release];
    [_daysFromBirthdayLabel release];
    [_daysAfterRecordLabel release];
    [_babyInfoToggle release]; 
    [_calendarView release];
    [_photoPickerController release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //config calendar view
    self.calendarView.delegate = self;
    
    //add guesture
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleBabyInfo:)];
    [self.calendarView.monthLabelButton addGestureRecognizer:recognizer];
    recognizer.numberOfTapsRequired = 2;
    [recognizer release];
    
    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(monthForward)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.calendarView addGestureRecognizer:swipeLeftGestureRecognizer];
    [swipeLeftGestureRecognizer release];
    
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(monthBack)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.calendarView addGestureRecognizer:swipeRightGestureRecognizer];
    [swipeRightGestureRecognizer release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //show editing baby view controller for create a baby if baby not existed
    if (self.baby == nil) {
        EditingBabyViewController *editingBabyVC = [[EditingBabyViewController alloc] initWithNibName:@"EditingBabyViewController" bundle:[NSBundle mainBundle]];
        editingBabyVC.title = @"添加宝宝信息";
        editingBabyVC.baby = [NSEntityDescription insertNewObjectForEntityForName:@"Baby" inManagedObjectContext:self.managedObjectContext];
        editingBabyVC.baby.creationDate = [NSDate date];
        UINavigationController *editingBabyNVC = [[UINavigationController alloc] initWithRootViewController:editingBabyVC];
        [self presentModalViewController:editingBabyNVC animated:YES];
        [editingBabyVC release];
        [editingBabyNVC release];
        return;
    }
    
    self.calendarView.miniumDate = self.baby.birthday;
    
    //fetch photos per day from database
    NSError *error;
    if (![self.photoResultsController performFetch:&error]) {
        //handle the error.
    }
    
    //config avatar shadow
    [self.avatarView.layer setCornerRadius:5];
    [self.avatarView.layer setShadowOffset:CGSizeMake(0, 1.0)];
    [self.avatarView.layer setShadowColor:[UIColor grayColor].CGColor];
    [self.avatarView.layer setShadowRadius:0];
    [self.avatarView.layer setShadowOpacity:0.8];
    
    //fetch lately photo
    Photo *latelyPhoto = [self _fetchLatelyPhoto];
    if (latelyPhoto) {
        //add real avatar for masks to bounds
        UIImageView *innerImageView = [[UIImageView alloc] initWithImage:latelyPhoto.b140Image];
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
        
        _firstShow = (UIButton *)[self.view viewWithTag:FIRST_SHOW_BUTTON_TAG];
        [_firstShow removeFromSuperview];
        
    }else {
        self.daysAfterRecordLabel.text = [NSString stringWithFormat:@"您还没有开始记录"];
        
        if ([self.view viewWithTag:FIRST_SHOW_BUTTON_TAG] == nil) {
            _firstShow = [[UIButton alloc] initWithFrame:self.view.bounds];
            _firstShow.tag = FIRST_SHOW_BUTTON_TAG;
            _firstShow.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:_firstShow];
            [_firstShow setBackgroundImage:[UIImage imageNamed:@"first-show.jpg"] forState:UIControlStateNormal];
            [_firstShow addTarget:_firstShow action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            [_firstShow release];
        }
    }
    
    //config baby info
    self.babyNameLabel.text = self.baby.nickName;
    self.daysFromBirthdayLabel.text = [NSString stringWithFormat:@"出生%@", [Utilities daysAfterBirthday:self.baby.birthday fromDate:[NSDate date]]];
    
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

#pragma mark - fetched result controller
- (NSFetchedResultsController *)photoResultsController {
    if (_photoResultsController != nil) {
        return _photoResultsController;
    }
    
    //create and configure a fetch request for Photo entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"recordDate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES], nil]];
    
    //create and init fetched result controller with section
    _photoResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"recordDateLabel" cacheName:nil];
    
    [request release];
    return _photoResultsController;
}

#pragma mark - MTCalendarViewDelegate
- (void)calendarView:(MTCalendarView *)calendarView didSelectDate:(NSDate *)date {
    MTCalendarCellView *cell = [calendarView cellForDate:date];
    if (cell.photos) {
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        photoBrowser.recordDate = date;
        NSUInteger initialPhotoIndex = [self.photoResultsController.fetchedObjects indexOfObject:[calendarView cellForDate:date].photo];
        [photoBrowser setInitialPageIndex:initialPhotoIndex];
        [self.navigationController pushViewController:photoBrowser animated:YES];
        [photoBrowser release];
    }else {
        // Show photos library for picking photo
        self.photoPickerController.recordDate = date;
        [self.photoPickerController photoLibraryAction];
    }
    
}

- (void)monthDidChangeOnCalendarView:(MTCalendarView *)calendarView {
    [self _showPhotosInCalendar];
}

- (void)didTouchDateBar {
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"设置" otherButtonTitles:nil, nil];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = self.calendarView.miniumDate;
    _datePicker.maximumDate = [NSDate date];
    [actionSheet addSubview:_datePicker];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.calendarView.selectedDate = _datePicker.date;
        [_datePicker release];
        [self _showPhotosInCalendar];
    }
}

#pragma mark - Photo browser delegate methods
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.photoResultsController.fetchedObjects count];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.photoResultsController.fetchedObjects objectAtIndex:index];
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    Photo *photo = [self.photoResultsController.fetchedObjects objectAtIndex:index];
    if (photo.caption == nil) {
        return nil;
    }
    return [[MTCaptionView alloc] initWithPhoto:[self.photoResultsController.fetchedObjects objectAtIndex:index]];
}

- (void)didFinishDeletePhotoInBrowser:(MWPhotoBrowser *)photoBrowser atIndex:(NSUInteger)index {
    NSError *error;
    [self.photoResultsController performFetch:&error];
    if (error) {
        // Handle error
    }
    if (index > [self.photoResultsController.fetchedObjects count] - 1) {
        index = [self.photoResultsController.fetchedObjects count] - 1;
    }
    
    [photoBrowser reloadData];
    
    [photoBrowser setInitialPageIndex:index];
}

@end
