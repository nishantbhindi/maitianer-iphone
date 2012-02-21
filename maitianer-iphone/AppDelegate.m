//
//  AppDelegate.m
//  maitianer-iphone
//
//  Created by 张 朝 on 11-11-22.
//  Copyright (c) 2011年 麦田儿. All rights reserved.
//

#include <SystemConfiguration/SCNetworkReachability.h>
#import "AppDelegate.h"
#import "EditingBabyViewController.h"
#import "CalendarViewController.h"
#import "MilestonesViewController.h"
#import "PhotoPickerController.h"
#import "FlurryAnalytics.h"
#import "Utilities.h"
#import "SVProgressHUD.h"

#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

@implementation UINavigationBar (CustomBackground)
- (UIImage *)barBackground {
    return [UIImage imageNamed:@"NavigationBar.png"];
}

- (void)didMoveToSuperview {
    //matching the button color with the bar color
    [self setTintColor:[UIColor colorWithRed:0 green:0.6f blue:0 alpha:0.7f]];
    
    //iOS5 only
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)drawRect:(CGRect)rect {
    // < iOS5
    UIImage *navBackgroundImage = [UIImage imageNamed:@"NavigationBar.png"];
    [navBackgroundImage drawInRect:rect];
}
@end


@implementation AppDelegate
@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController;
@synthesize wbEngine = _wbEngine;
@synthesize previousSelectedTabIndex = _previousSelectedTabIndex;

//void uncaughtExceptionHandler(NSException *exception) {
//    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Flurry
    //NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"YHJ3T4Z3ZQR6KGK96X7E"];
    
    // Show the status bar with black opaque style
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    // Set default timezone
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    // Initial weibo api
    _wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [_wbEngine setRootViewController:self.tabBarController];
    [_wbEngine setDelegate:self];
    [_wbEngine setRedirectURI:@"http://"];
    [_wbEngine setIsUserExclusive:NO];
    
    CalendarViewController *calendarVC = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:[NSBundle mainBundle]];
    calendarVC.managedObjectContext = self.managedObjectContext;
    UINavigationController *calendarNVC = [[UINavigationController alloc] initWithRootViewController:calendarVC];
    calendarNVC.navigationBarHidden = YES;
    
    PhotoPickerController *photoPickerController = [[PhotoPickerController alloc] initWithDelegate:self];
    calendarVC.photoPickerController = photoPickerController;
    
    MilestonesViewController *milestonesVC = [[MilestonesViewController alloc] init];
    milestonesVC.managedObjectContext = self.managedObjectContext;
    UINavigationController *milestonesNVC = [[UINavigationController alloc] initWithRootViewController:milestonesVC];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = [NSArray arrayWithObjects:calendarNVC, photoPickerController, milestonesNVC, nil];
    _tabBarController.delegate = self;
    [calendarVC release];
    [photoPickerController release];
    [milestonesVC release];
    [calendarNVC release];
    [milestonesNVC release];
    
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_tabBarController release];
    [_wbEngine release];
    [super dealloc];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"maitianer_iphone" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectoryURL] URLByAppendingPathComponent:@"maitianer_iphone.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Network connection status method
- (BOOL)hasNetworkConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "60.190.99.152");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkReachabilityFlagsReachable & flags) || (kSCNetworkReachabilityFlagsConnectionRequired & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}
- (BOOL)hasWiFiConnection {
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "60.190.99.152");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkFlagsReachable & flags) && !(kSCNetworkReachabilityFlagsIsWWAN & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // If selected tab for photo picker restore the previous controller and show the picker
    if ([viewController isKindOfClass:[PhotoPickerController class]]) {
        [(PhotoPickerController *)viewController cameraAction];
        tabBarController.selectedIndex = self.previousSelectedTabIndex;
    }
    
    // if selected tab isn't photo picker store the current tab index
    self.previousSelectedTabIndex = tabBarController.selectedIndex;
}

#pragma mark - PhotoPickerControllerDelegate
- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera {
    // Save the photo
    NSDate *recordDate;
    if (controller.recordDate) {
        recordDate = controller.recordDate;
    }else {
        recordDate = [NSDate date];
    }
    
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    photo.baby = [[Utilities fetchBabies] objectAtIndex:0];
    photo.recordDate = [recordDate beginningOfDay];
    photo.creationDate = [NSDate date];
    photo.shared = [NSNumber numberWithBool:NO];
    [photo saveImage:image baseDirectory:[Utilities photoStorePathByDate:recordDate]];
    [self saveContext];
    
    // Reset the photo picker record date
    controller.recordDate = nil;
}

#pragma mark - WBEngineDelegate
- (void)engineDidLogIn:(WBEngine *)engine {
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"绑定成功" afterDelay:2];
    [FlurryAnalytics logEvent:@"BindedSinaWeibo"];
}

- (void)engineDidLogOut:(WBEngine *)engine {
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"您已成功解除绑定" afterDelay:2];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error {
    NSLog(@"帐号绑定失败！错误信息：%@", [error description]);
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"绑定失败" afterDelay:2];
}
@end
