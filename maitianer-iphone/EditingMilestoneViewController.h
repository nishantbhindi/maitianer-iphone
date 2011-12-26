//
//  EditingMilestoneViewController.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-12-21.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Milestone.h"
#import "Photo.h"

@interface EditingMilestoneViewController : UIViewController {
    UITextView *_milestoneText;
    Milestone *_milestone;
    Photo *_photo;
    BOOL _editing;
}

@property (nonatomic, retain) IBOutlet UITextView *milestoneText;
@property (nonatomic, retain) Milestone *milestone;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, assign) BOOL editing;

- (void)cancelEditing;
- (void)saveEditing;

@end
