//
//  MilestonesViewController.h
//  maitianer-iphone
//
//  Created by lee rock on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MilestonesViewController : UITableViewController {
    NSMutableArray *_milestones;
}

@property (nonatomic, retain) NSMutableArray *milestones;

@end
