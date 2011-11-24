//
//  DKFile.m
//  DiscoKit
//
//  Created by Keith Pitt on 30/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKFile.h"

@implementation DKFile

@synthesize path;

+ (id)fileFromDocuments:(NSString *)fileName {
    
    // Look in the documents directory
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // Create the file path
    NSString * filePath = [rootPath stringByAppendingPathComponent:fileName];
    
    // Create an autoreleased DKFile
    return [[[self alloc] initWithPath:filePath] autorelease];
    
}

+ (id)fileFromBundle:(NSBundle *)bundle pathForResource:(NSString *)path ofType:(NSString *)type {
    
    // What bundle do we want to use?
    NSBundle * sourceBundle = bundle ? bundle : [NSBundle mainBundle];
    
    // Find the path of the file
    NSString * filePath = [sourceBundle pathForResource:path ofType:type];
    
    // Create an autoreleased DKFile
    return [[[self alloc] initWithPath:filePath] autorelease];
    
}

- (id)initWithPath:(NSString *)filePath {
    
    if ((self = [super init])) {
        self.path = filePath;
    }
    
    return self;
    
}

- (BOOL)writeData:(NSData *)data error:(NSError **)error {
    
    return [data writeToFile:path options:NSDataWritingAtomic error:error];
    
}

- (BOOL)delete:(NSError **)error {
    
    // Only go to delete if we have the file
    if ([self exists]) {
        
        // Create an instance of the file manager. We don't use the shared
        // one because its not thread safe.
        NSFileManager * fileManager = [NSFileManager new];
        
        // Delete the file
        BOOL success = [fileManager removeItemAtPath:path error:error];
        
        // Release the file manager
        [fileManager release];
        
        return success;
        
    } else {
        
        return NO;
        
    }
    
}

- (NSString *)contents {
    
    NSError * error = nil;
    
    // Blocking way of reading the file
    NSString * contents = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    
    // TODO: Come up with a pattern to handle this error.
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        abort();
    }
    
    return contents;
    
}

- (BOOL)exists {
    
    // Create an instance of the NSFileManager because the shared
    // version isn't thread safe.
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    
    // Does the file exist?
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    // Release the file manager
    [fileManager release];
    
    return fileExists;
    
}

- (NSInteger)size {
    
    // Create an instance of the NSFileManager because the shared
    // version isn't thread safe.
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    
    // Grab the file attributes for the file
    NSError *error = nil;
    NSDictionary * fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    
    // Release the file mananger
    [fileManager release];
    
    // Return the file modification date
    return [fileAttributes fileSize];
    
}

- (NSDate *)lastModificationDate {
    
    // Create an instance of the NSFileManager because the shared
    // version isn't thread safe.
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    
    // Grab the file attributes for the file
    NSError *error = nil;
    NSDictionary * fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    
    // Release the file mananger
    [fileManager release];
    
    // Return the file modification date
    return [fileAttributes fileModificationDate];
    
}

- (NSTimeInterval)age {
    
    // The modification date of the file
    NSDate * modified = [self lastModificationDate];
    
    // The time interval from now
    return [[NSDate date] timeIntervalSinceDate:modified];
    
}

- (NSString *)description {
    
    // Find the file size out for the file
    NSInteger fileSizeInBytes = [self size];
    NSInteger fileSizeInKilobytes = fileSizeInBytes / 1000.0;
    
    // A more interesting message for NSLog
    return [NSString stringWithFormat:@"<DKFile: \"%@\" (%llu kilobytes)>", self.path, fileSizeInKilobytes];
    
}

- (id)formData:(DKAPIFormData *)formData valueForParameter:(NSString *)param {
    
    return self.path;
    
}

- (int)formData:(DKAPIFormData *)formData dataTypeForParameter:(NSString *)param {
    
    return 2;
    
}

- (void)dealloc {
    
    self.path = nil;
    
    [super dealloc];
    
}

@end