//
//  NSManagedObject+JSON.m
//  maitianer-iphone
//
//  Created by 张 朝 on 12-1-14.
//  Copyright (c) 2012年 麦田儿. All rights reserved.
//

#import "NSManagedObject+JSON.h"

@implementation NSManagedObject (JSON)
- (id)proxyForJson {
    NSMutableDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSURL *idURI = [[self objectID] URIRepresentation];
    [properties setObject:[idURI description] forKey:@"id"];
    
    for (id property in [[self entity] properties]) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSString *name = [(NSAttributeDescription *)property name];
            if ([self valueForKey:name]) {
                if ([[self valueForKey:name] isKindOfClass:[NSDate class]]) {
                    NSDate *date = [self valueForKey:name];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [properties setObject:[dateFormatter stringFromDate:date] forKey:name];
                    [dateFormatter release];
                }else {
                    [properties setObject:[self valueForKey:name] forKey:name];
                }
            }else {
                [properties setObject:@"" forKey:name];
            }
        }else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = [relationshipDescription name];
            if ([self valueForKey:name]) {
                if (![relationshipDescription isToMany]) {
                    NSManagedObject *o = [self valueForKey:name];
                    NSURL *idURI = [[o objectID] URIRepresentation];
                    [properties setObject:[idURI description] forKey:name];
                }
            }else {
                [properties setObject:@"" forKey:name];
            }
            
        }
    }
    
    return properties;
}
@end
