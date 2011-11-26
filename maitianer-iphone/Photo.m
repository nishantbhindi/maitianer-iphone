//
//  Photo.m
//  maitianer-iphone
//
//  Created by lee rock on 11-11-26.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import "Photo.h"
#import "Baby.h"


@implementation Photo

@dynamic content;
@dynamic creationDate;
@dynamic path;
@dynamic recordDate;
@dynamic shared;
@dynamic title;
@dynamic baby;

- (NSString *)recordDateLabel {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *recordDateLabel = [dateFormatter stringFromDate:self.recordDate];
    [dateFormatter release];
    return recordDateLabel;
}

@end
