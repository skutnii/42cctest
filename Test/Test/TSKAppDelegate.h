//
//  TSKAppDelegate.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TSKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NSManagedObjectModel *dataModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *storeManager;
@property (strong, nonatomic) NSPersistentStore *dataStore;
@property (strong, nonatomic) NSManagedObjectContext *dataContext;

@end