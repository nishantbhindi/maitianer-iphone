//
//  JSONRequest.h
//  maitianer-iphone
//
//  Created by 张 朝 on 12-2-8.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONRequest;

@protocol JSONRequestDelegate
- (void) jsonDidFinishLoading:(NSDictionary*)json jsonRequest:(JSONRequest*)request;
- (void) jsonDidFailWithError:(NSError*)error jsonRequest:(JSONRequest*)request;
@end

@interface JSONRequest : NSObject {	
	NSString *path;
	NSString *method;
	NSString *body;
	NSArray *cookies;
    
	NSMutableData *temp;
	id <JSONRequestDelegate> delegate;
    
	NSHTTPURLResponse *response;
}

@property (nonatomic, retain) NSString* path;
@property (nonatomic, retain) NSString* method;
@property (nonatomic, retain) NSString* body;
@property (nonatomic, retain) NSArray* cookies;
@property (nonatomic, retain) NSMutableData* temp;
@property (nonatomic, retain) NSHTTPURLResponse* response;
@property (nonatomic, assign) id <JSONRequestDelegate> delegate;

- (id) initGetWithPath:(NSString*)aPath delegate:(id<JSONRequestDelegate>)aDelegate;
- (id) initPostWithPath:(NSString*)aPath httpBody:(NSString*)aBody delegate:(id<JSONRequestDelegate>)aDelegate;
- (id) initPostWithPath:(NSString*)aPath parameters:(NSDictionary*)params delegate:(id<JSONRequestDelegate>)aDelegate;

+(NSString*) endPoint;
+(NSString*) alterPath:(NSString*)path;

- (void) jsonFinishedLoading:(NSDictionary*)json;
@end
