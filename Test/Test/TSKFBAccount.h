//
//  TSKFBAccount.h
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"

@interface TSKFBAccount : NSObject

-(id)initWithSession:(FBSession*)session;
-(id)profile;
-(NSArray*)friends;

@end
