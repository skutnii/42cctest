//
//  TSKLoadQueueManager.m
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//



#import "TSKLoadQueueManager.h"
#import "TSKAppDelegate.h"

@implementation TSKLoadQueueManager

+(void)scheduleTransaction:(TSKLoadTransaction)ta
{
    static dispatch_queue_t loadQueue = NULL;
    if (!loadQueue)
    {
        loadQueue = dispatch_queue_create("LoadQueue", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(loadQueue, ta);
}

+(TSKLoadTransaction)exceptionHandleDecoratedTransaction:(TSKLoadTransaction)ta
{
    TSKLoadTransaction safeTransaction = ^{
        @try
        {
            ta();
        }
        @catch (NSException *exception)
        {
            TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
            [appDelegate handleException:exception];
        }
        @catch (...)
        {
        }
    };
    
    return safeTransaction;
}

@end
