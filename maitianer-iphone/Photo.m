//
//  Photo.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-26.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "Photo.h"
#import "Baby.h"
#import "Milestone.h"
#import "DKFile.h"

typedef enum PhotoImageVersionT {
    PhotoImageVersionOrigin,
    PhotoImageVersionNormal,
    PhotoImageVersionB200
}PhotoImageVersion;

@implementation Photo

@dynamic content;
@dynamic creationDate;
@dynamic path;
@dynamic recordDate;
@dynamic shared;
@dynamic title;
@dynamic baby;
@dynamic milestone;

@synthesize originImage;
@synthesize image;
@synthesize b200Image;

- (NSString *)recordDateLabel {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *recordDateLabel = [dateFormatter stringFromDate:self.recordDate];
    [dateFormatter release];
    return recordDateLabel;
}

- (UIImage *)_imageForVersion:(PhotoImageVersion)photoImageVersion {
    
    NSArray *pathComponents = [self.path componentsSeparatedByString:@"."];
    NSString *pathWithoutExt = [pathComponents objectAtIndex:0];
    NSString *fileExtsion = [pathComponents objectAtIndex:1];
    NSString *versionString = nil;
    if (photoImageVersion == PhotoImageVersionOrigin) {
        versionString = @"-origin";
    }else if (photoImageVersion == PhotoImageVersionB200) {
        versionString = @"-b200";
    }else {
        versionString = @"";
    }
    
    DKFile *dkFile = [DKFile fileFromDocuments:[NSString stringWithFormat:@"%@%@.%@", pathWithoutExt, versionString,fileExtsion]];
    
    return [UIImage imageWithContentsOfFile:dkFile.path];
}

- (UIImage *)originImage {
    return [self _imageForVersion:PhotoImageVersionOrigin];
}

- (UIImage *)image {
    return [self _imageForVersion:PhotoImageVersionNormal];
}

- (UIImage *)b200Image {
    return [self _imageForVersion:PhotoImageVersionB200];
}

@end
