//
//  Photo.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-26.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby, Milestone;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * lastModifiedByDate;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * recordDate;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) Baby *baby;
@property (nonatomic, retain) Milestone *milestone;

@property (nonatomic, readonly) UIImage *originImage;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIImage *b200Image;
@property (nonatomic, readonly) UIImage *b140Image;

- (NSString *)recordDateLabel;

@end
