//
//  TSKAppDelegate.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TSKFBAccount;

@interface TSKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, readonly) TSKFBAccount *fbAccount;

-(void)handleException:(NSException*)exc;
-(void)logout;
-(NSString*)appDocumentsDirectory;

@end
