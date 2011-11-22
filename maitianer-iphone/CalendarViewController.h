//
//  CalendarViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Baby.h"

@interface CalendarViewController : UIViewController {
    NSManagedObjectContext *_managedObjectContext;
    Baby *_baby;
    
    IBOutlet UILabel *_babyNameLabel;
    IBOutlet UILabel *_daysFromBirthdayLabel;
    IBOutlet UILabel *_daysAfterRecord;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Baby *baby;

@property (nonatomic, retain) UILabel *babyNameLabel;
@property (nonatomic, retain) UILabel *daysFromBirthdayLabel;
@property (nonatomic, retain) UILabel *daysAfterRecord;

@end
