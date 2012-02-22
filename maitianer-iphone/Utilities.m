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
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
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

+ (NSString *)generateUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@", (NSString *)uuidString];
    CFRelease(uuidString);
    return uniqueFileName;
}

+ (NSString *)photoStorePathByDate:(NSDate *)date {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    
    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *subPath = [NSString stringWithFormat:@"photos/%d/%d/%d", year, month, day];
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:subPath];
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		if (![[NSFileManager defaultManager] createDirectoryAtPath:path
									   withIntermediateDirectories:YES
														attributes:nil
															 error:&error]) {
			NSLog(@"Create directory error: %@", error);
		}
	}
    
    return subPath;
}

+ (NSString *)daysAfterBirthday:(NSDate *)birthday fromDate:(NSDate *)date {
    NSString *daysAfterBirthday;
    if ([[birthday nextYear] isEqualToDateIgnoringTime:date]) {
        daysAfterBirthday = @"一年";
    }else if ([[birthday nextYear] isLaterThanDate:[date beginningOfDay]]) {
        daysAfterBirthday = [NSString stringWithFormat:@"%d天", [date daysAfterDate:birthday]];
    }else {
        NSInteger yearsAfter = [date year] - [birthday year];
        int daysFromBeginningOfYear = [[birthday yearsSince:yearsAfter] daysBeforeDate:date];
        daysAfterBirthday = [NSString stringWithFormat:@"%d年%d天", yearsAfter, daysFromBeginningOfYear];
    }
    
    return daysAfterBirthday;
}

+ (NSManagedObjectContext *)moc {
    return [Utilities appDelegate].managedObjectContext;
}

+ (NSArray *)fetchBabies {
    //fetch babies from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Baby"];
    NSError *error = nil;
    NSArray *babiesArray = [[Utilities moc] executeFetchRequest:request error:&error];
    if (babiesArray == nil) {
        //Handle the error.
    }
    return babiesArray;
}

@end
