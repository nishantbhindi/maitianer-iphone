//
//  Utilities.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-8.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (AppDelegate *)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *result = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return result;
}

+ (NSDate *)dateFromString:(NSString *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *result = [dateFormatter dateFromString:date];
    [dateFormatter release];
    return result;
}

@end
