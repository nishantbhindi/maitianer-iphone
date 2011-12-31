//
//  PhotosViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo, PhotographViewController;

@interface PhotosViewController : UITableViewController {
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_fetchedRequestController;
    NSIndexPath *_selectedIndexPath;
    NSDate *_recordDate;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedRequestController;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) Photo *selectedPhoto;
@property (nonatomic, retain) NSDate *recordDate;

- (void)addMilestone;
- (void)editPhoto;


@end
