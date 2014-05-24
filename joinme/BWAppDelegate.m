//
//  BWAppDelegate.m
//  joinme
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "BWAppDelegate.h"
#import "BWListActivityController.h"
#import "BWDBManager.h"

@implementation BWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor greenColor];
//    [self.window makeKeyAndVisible];
    [self initData];
    return YES;
}

- (void)initData
{
    NSMutableArray *items = [[BWDBManager getSharedInstance] findAll];
    [[self getControllerDataModel] setItems:items];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSMutableArray *array = [[self getControllerDataModel] items];
//    [self saveDataToPropertyFile:array];
//    [self saveDataToDatabase:array];
}

- (BWListActivityController *)getControllerDataModel
{
    UINavigationController *rootCtr = (UINavigationController *)self.window.rootViewController;
    return (BWListActivityController *) [[rootCtr viewControllers] objectAtIndex:0];
}

- (void)saveDataToDatabase:(NSMutableArray *) array
{
    for (int i = 0; i < [array count]; i++)
    {
        BWActivity * item = (BWActivity *)array[i];
        [[BWDBManager getSharedInstance] create:[item itemName]];
    }
}

- (void)saveDataToPropertyFile:(NSMutableArray *) array
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"Root path : %@", rootPath);
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TodoItems.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:array forKeys:[NSArray arrayWithObjects:@"item", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    [plistData writeToFile:plistPath atomically:YES];
}

@end
