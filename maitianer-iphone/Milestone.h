//
//  Milestone.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-12-28.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby, Photo;

@interface Milestone : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * lastModifiedByDate;
@property (nonatomic, retain) NSDate * recordDate;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) Baby *baby;
@property (nonatomic, retain) Photo *photo;

@end
