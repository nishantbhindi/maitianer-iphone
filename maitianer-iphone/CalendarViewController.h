//
//  CalendarViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"
#import "Photo.h"
#import "MTCalendarView.h"
#import "MWPhotoBrowser.h"

@class PhotoPickerController;

@interface CalendarViewController : UIViewController <MTCalendarViewDelegate, UIActionSheetDelegate, MWPhotoBrowserDelegate> {
    // CoreData
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_photoResultsController;
    Baby *_baby;
    
    // View
    UIButton *_firstShow;
    UIDatePicker *_datePicker;
    IBOutlet UIView *_babyInfoView;
    IBOutlet UIImageView *_avatarView;
    IBOutlet UILabel *_babyNameLabel;
    IBOutlet UILabel *_daysFromBirthdayLabel;
    IBOutlet UILabel *_daysAfterRecordLabel;
    IBOutlet UIButton *_babyInfoToggle;
    IBOutlet MTCalendarView *_calendarView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *photoResultsController;
@property (nonatomic, retain) Baby *baby;

@property (nonatomic, retain) UIView *babyInfoView;
@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) UILabel *babyNameLabel;
@property (nonatomic, retain) UILabel *daysFromBirthdayLabel;
@property (nonatomic, retain) UILabel *daysAfterRecordLabel;
@property (nonatomic, retain) UIButton *babyInfoToggle;
@property (nonatomic, retain) MTCalendarView *calendarView;
@property (nonatomic, retain) PhotoPickerController *photoPickerController;

- (IBAction)toggleBabyInfo:(id)sender;
- (IBAction)showSettings:(id)sender;

@end
