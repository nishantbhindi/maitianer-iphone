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
