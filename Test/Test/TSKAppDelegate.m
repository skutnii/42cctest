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
#import "Person.h"
#import "Phone.h"
#import "Email.h"
#import "Messenger.h"
#import "FacebookSDK.h"

#define FIRSTRUN 0

@interface TSKAppDelegate ()

-(NSString*)appDocumentsDirectory;

@end

@implementation TSKAppDelegate

@synthesize dataModel = _dataModel;
@synthesize storeManager = _storeManager;
@synthesize dataStore = _dataStore;
@synthesize dataContext = _dataContext;

-(NSManagedObjectContext*)dataContext
{
    if (!_dataContext)
    {
        _dataContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        _dataContext.persistentStoreCoordinator = self.storeManager;
    }
    
    return _dataContext;
}

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

        NSString *docsDir = [self appDocumentsDirectory];
        NSString *storePath = [docsDir stringByAppendingPathComponent:@"TestData.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        NSFileManager *fManager = [NSFileManager defaultManager];
        if (![fManager fileExistsAtPath:storePath])
        {
            NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"data"];
            [fManager copyItemAtPath:defaultsPath toPath:storePath error:NULL];
        }
        
        NSPersistentStore *aStore = [_storeManager persistentStoreForURL:storeURL];
        if (!aStore)
        {
            NSError *err = nil;
            aStore = [_storeManager
                      addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                      URL:storeURL options:nil error:&err];
            if (err)
            {
                NSLog(@"%@", [err description]);
            }
        }
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
        
        _dataStore = [self.storeManager persistentStoreForURL:storeURL];
    }
    
    return _dataStore;
}

-(void)createDefaultData
{
    NSManagedObjectContext *objContext = self.dataContext;
    NSEntityDescription *metaPerson = [NSEntityDescription
                                       entityForName:@"Person" inManagedObjectContext:objContext];
    
    Person *me = [[Person alloc] initWithEntity:metaPerson insertIntoManagedObjectContext:objContext];
    me.name = @"Sergii";
    me.surname = @"Kutnii";
    
    NSDateComponents *birthComps = [[NSDateComponents alloc] init];
    birthComps.year = 1985;
    birthComps.month = 1;
    birthComps.day = 26;
    
    me.birthDate = [[NSCalendar currentCalendar] dateFromComponents:birthComps];
    me.bio = @"Born. Went to kindergarten then to school. Studied physics in Taras Shevchenko Kiev university. Worked for several outsourcing companies before turning to freelance. Babylon 5 fan.";
    me.photo = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Me128" ofType:@"jpg"]];
    
    NSEntityDescription *metaPhone = [NSEntityDescription entityForName:@"Phone" inManagedObjectContext:objContext];
    Phone *phone = [[Phone alloc] initWithEntity:metaPhone insertIntoManagedObjectContext:objContext];
    phone.info = @"Mobile";
    phone.number = @"+380968882443";
    
    me.phones = [NSSet setWithObject:phone];
    
    NSEntityDescription *metaEmail = [NSEntityDescription entityForName:@"Email" inManagedObjectContext:objContext];
    Email *email = [[Email alloc] initWithEntity:metaEmail insertIntoManagedObjectContext:objContext];
    email.info = @"Main email address";
    email.address = @"mnkutster@gmail.com";
    
    me.emails = [NSSet setWithObject:email];
    
    NSEntityDescription *metaMessenger = [NSEntityDescription
                                          entityForName:@"Messenger" inManagedObjectContext:objContext];
    
    Messenger *skype = [[Messenger alloc] initWithEntity:metaMessenger insertIntoManagedObjectContext:objContext];
    skype.type = @"Skype";
    skype.nickname = @"skutphys";
    
    Messenger *jabber = [[Messenger alloc] initWithEntity:metaMessenger insertIntoManagedObjectContext:objContext];
    jabber.type = @"Jabber";
    jabber.nickname = @"skutnii@jabb3r.net";
    
    me.messengers = [NSSet setWithObjects:skype, jabber, nil];
    
    NSError *err = nil;
    [objContext save:&err];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[TSKFirstViewController alloc] initWithNibName:@"TSKFirstViewController" bundle:nil];
    UIViewController *viewController2 = [[TSKSecondViewController alloc] initWithNibName:@"TSKSecondViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    NSArray *tabItems = self.tabBarController.tabBar.items;
    UITabBarItem *firstItem = [tabItems objectAtIndex:0];
    firstItem.title = @"Info";
    UITabBarItem *secondItem = [tabItems objectAtIndex:1];
    secondItem.title = @"Contacts";
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
#if FIRSTRUN
    [self createDefaultData];
#endif
    
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
