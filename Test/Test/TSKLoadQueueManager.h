//
//  TSKLoadQueueManager.h
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TSKLoadTransaction)();

@interface TSKLoadQueueManager : NSObject

+(void)scheduleTransaction:(TSKLoadTransaction)ta;
+(TSKLoadTransaction)exceptionHandleDecoratedTransaction:(TSKLoadTransaction)ta;

@end
