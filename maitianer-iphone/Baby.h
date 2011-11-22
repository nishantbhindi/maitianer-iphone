//
//  Baby.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Baby : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * fatherName;
@property (nonatomic, retain) NSString * motherName;
@property (nonatomic, retain) NSNumber * birthWeight;

@end
