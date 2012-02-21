//
//  AppDelegate.h
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "PhotoPickerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, PhotoPickerControllerDelegate, WBEngineDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) UITabBarController *tabBarController;
@property (readonly, retain, nonatomic) WBEngine *wbEngine;
@property (assign, nonatomic) NSUInteger previousSelectedTabIndex;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectoryPath;
- (NSURL *)applicationDocumentsDirectoryURL;
- (BOOL)hasNetworkConnection;
- (BOOL)hasWiFiConnection;

@end
