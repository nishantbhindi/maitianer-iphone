//
//  Utilities.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-8.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NSDate-Utilities.h"
#import "NSDate+Calculations.h"

@interface Utilities : NSObject

+ (AppDelegate *)appDelegate;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)date withFormat:(NSString *)format;
+ (NSString *)generateUUID;
+ (NSString *)photoStorePathByDate:(NSDate *)date;

// Core Data
+ (NSManagedObjectContext *)moc;
+ (NSArray *)fetchBabies;

@end
