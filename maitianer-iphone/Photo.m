//
//  Photo.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-26.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "Photo.h"
#import "Baby.h"
#import "Milestone.h"
#import "DKFile.h"
#import "Utilities.h"
#import "UIImage+ProportionalFill.h"

typedef enum PhotoImageVersionT {
    PhotoImageVersionOrigin,
    PhotoImageVersionNormal,
    PhotoImageVersionB140
}PhotoImageVersion;

@interface Photo ()
- (void)saveImage:(UIImage *)img toPath:(NSString *)path;
- (NSString *)imagePathForVersion:(PhotoImageVersion)photoImageVersion;
@end

@implementation Photo

@dynamic content;
@dynamic creationDate;
@dynamic lastModifiedByDate;
@dynamic path;
@dynamic recordDate;
@dynamic shared;
@dynamic title;
@dynamic deleted;
@dynamic photoId;
@dynamic baby;
@dynamic milestone;

@synthesize originImage;
@synthesize image;
@synthesize b140Image;

- (NSString *)recordDateLabel {
    return [Utilities stringFromDate:self.recordDate withFormat:@"yyyy-MM-dd"];
}

- (void)saveImage:(UIImage *)img baseDirectory:(NSString *)directoryPath {
    NSString *fileNameUUID = [Utilities generateUUID];
    self.path = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileNameUUID]];
    
    //store the origin image picked
    [self saveImage:img toPath:[self imagePathForVersion:PhotoImageVersionOrigin]];
    
    //resize the origin image for thumbnail 640x640 and store it
    [self saveImage:img toPath:[self imagePathForVersion:PhotoImageVersionNormal]];
    
    //resize the origin image for thumbnail 140x140 and store it
    [self saveImage: [img imageCroppedToFitSize:CGSizeMake(140, 140)] toPath:[self imagePathForVersion:PhotoImageVersionB140]];
    
}

- (UIImage *)_imageForVersion:(PhotoImageVersion)photoImageVersion {
    
    NSArray *pathComponents = [self.path componentsSeparatedByString:@"."];
    NSString *pathWithoutExt = [pathComponents objectAtIndex:0];
    NSString *fileExtsion = [pathComponents objectAtIndex:1];
    NSString *versionString = nil;
    if (photoImageVersion == PhotoImageVersionOrigin) {
        versionString = @"-origin";
    }else if (photoImageVersion == PhotoImageVersionB140) {
        versionString = @"-b140";
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

- (UIImage *)b140Image {
    return [self _imageForVersion:PhotoImageVersionB140];
}

- (NSString *)daysAfterBirthday {
    return [Utilities daysAfterBirthday:self.baby.birthday fromDate:self.recordDate];
}

#pragma mark - Private
- (void)saveImage:(UIImage *)img toPath:(NSString *)path {
    DKFile *file = [DKFile fileFromDocuments:path];
    NSError *error = nil;
    if ([file writeData:UIImageJPEGRepresentation(img, 0.8) error:&error]) {
        NSLog(@"File save success!");
    }else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (NSString *)imagePathForVersion:(PhotoImageVersion)photoImageVersion {
    NSArray *pathComponents = [self.path componentsSeparatedByString:@"."];
    NSString *pathWithoutExt = [pathComponents objectAtIndex:0];
    NSString *fileExtsion = [pathComponents objectAtIndex:1];
    NSString *versionString = nil;
    if (photoImageVersion == PhotoImageVersionOrigin) {
        versionString = @"-origin";
    }else if (photoImageVersion == PhotoImageVersionB140) {
        versionString = @"-b140";
    }else {
        versionString = @"";
    }
    
    return [NSString stringWithFormat:@"%@%@.%@", pathWithoutExt, versionString, fileExtsion];
}

#pragma mark - MWPhoto 
- (UIImage *)underlyingImage {
    return self.image;
}

- (void)loadUnderlyingImageAndNotify {
    
}

- (void)unloadUnderlyingImage {
    
}

- (NSString *)caption {
    return self.content;
}

@end
