//
//  TSKAppDelegate.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FacebookSDK.h"

extern NSString * const kLoginStateChangeNotification;

@class TSKFBAccount;

@interface TSKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) FBSession *fbSession;
@property (nonatomic, readonly) TSKFBAccount *fbAccount;

-(void)handleException:(NSException*)exc;
-(void)logout;
-(void)authenticate;
-(NSString*)appDocumentsDirectory;

@end
