//
//  AppDelegate.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConnect.h"

@class MTTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    WeiBo *_weibo;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, retain, nonatomic) WeiBo *weibo;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
