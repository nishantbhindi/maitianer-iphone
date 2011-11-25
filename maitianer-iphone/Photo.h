//
//  Photo.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-25.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * recoredDate;
@property (nonatomic, retain) NSNumber * shared;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Baby *baby;

@end
