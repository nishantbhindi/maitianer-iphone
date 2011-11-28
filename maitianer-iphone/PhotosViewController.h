//
//  PhotosViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-27.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UITableViewController {
    NSArray *_photos;
    NSArray *_milestones;
    NSIndexPath *_selectedIndexPath;
}

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSArray *milestones;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end
