//
//  Baby.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-9.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Milestone, Photo;

@interface Baby : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * birthWeight;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * fatherName;
@property (nonatomic, retain) NSDate * lastModifiedByDate;
@property (nonatomic, retain) NSString * motherName;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * babyId;
@property (nonatomic, retain) NSSet *milestones;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Baby (CoreDataGeneratedAccessors)

- (void)addMilestonesObject:(Milestone *)value;
- (void)removeMilestonesObject:(Milestone *)value;
- (void)addMilestones:(NSSet *)values;
- (void)removeMilestones:(NSSet *)values;
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
@end
