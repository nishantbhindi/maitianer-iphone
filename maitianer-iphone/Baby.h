//
//  Baby.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-12-15.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Milestone, Photo;

@interface Baby : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * birthWeight;
@property (nonatomic, retain) NSString * fatherName;
@property (nonatomic, retain) NSString * motherName;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *milestones;
@end

@interface Baby (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
- (void)addMilestonesObject:(Milestone *)value;
- (void)removeMilestonesObject:(Milestone *)value;
- (void)addMilestones:(NSSet *)values;
- (void)removeMilestones:(NSSet *)values;
@end
