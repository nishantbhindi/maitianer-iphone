//
//  PhotosViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotosViewController : UITableViewController {
    NSManagedObjectContext *_managedObjectContext;
    NSArray *_photos;
    NSArray *_milestones;
    NSIndexPath *_selectedIndexPath;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSArray *milestones;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) Photo *selectedPhoto;

- (void)addMilestone;
- (void)editPhoto;
- (void)removePhoto;


@end
