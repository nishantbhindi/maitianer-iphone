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
    NSMutableArray *_photos;
    NSArray *_milestones;
    NSIndexPath *_selectedIndexPath;
    PhotographViewController *_photographVC;
    NSDate *_recordDate;
}

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) NSArray *milestones;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) Photo *selectedPhoto;
@property (nonatomic, retain) PhotographViewController *photographVC;
@property (nonatomic, retain) NSDate *recordDate;

- (void)addMilestone;
- (void)editPhoto;
- (void)removePhoto;


@end
