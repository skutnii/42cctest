//
//  TSKAppDelegate.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKAppDelegate.h"
#import "TSKFirstViewController.h"
#import "TSKSecondViewController.h"
#import <CoreData/CoreData.h>

@interface TSKAppDelegate ()

-(NSString*)appDocumentsDirectory;

@end

@implementation TSKAppDelegate

@synthesize dataModel = _dataModel;
@synthesize storeManager = _storeManager;
@synthesize dataStore = _dataStore;

-(NSManagedObjectModel*)dataModel
{
    if (!_dataModel)
    {
        _dataModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _dataModel;
}

-(NSPersistentStoreCoordinator*)storeManager
{
    if (!_storeManager)
    {
        _storeManager = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.dataModel];
    }
    
    return _storeManager;
}

-(NSPersistentStore*)dataStore
{
    if (!_dataStore)
    {
        NSString *docsDir = [self appDocumentsDirectory];
        NSString *storePath = [docsDir stringByAppendingPathComponent:@"TestData.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        NSPersistentStoreCoordinator *manager = self.storeManager;
        NSPersistentStore *aStore = [manager persistentStoreForURL:storeURL];
        if (!aStore)
        {
            NSError *err = nil;
            aStore = [manager
                      addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                      URL:storeURL options:nil error:&err];
            if (err)
            {
                NSLog(@"%@", [err description]);
            }
        }
        
        _dataStore = aStore;
    }
    
    return _dataStore;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[TSKFirstViewController alloc] initWithNibName:@"TSKFirstViewController" bundle:nil];
    UIViewController *viewController2 = [[TSKSecondViewController alloc] initWithNibName:@"TSKSecondViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [self dataStore];
    
    return YES;
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
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(NSString*)appDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

@end
