//
//  Authorization.m
//  maitianer-iphone
//
//  Created by lee rock on 12-2-7.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "Authorization.h"

@interface Authorization : NSObject {
}

+(void) deleteAuthorization;

// Cookies
+(void) setCookies:(NSArray*)cookies;
+(NSArray*) cookies;

@end
