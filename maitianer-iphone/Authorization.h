//
//  Authorization.h
//  maitianer-iphone
//
//  Created by lee rock on 12-2-7.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject {
}

+(void) deleteAuthorization;

// Cookies
+(void) setCookies:(NSArray*)cookies;
+(NSArray*) cookies;

@end
