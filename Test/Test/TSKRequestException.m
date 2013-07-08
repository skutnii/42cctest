//
//  TSKRequestException.m
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKRequestException.h"

@implementation TSKRequestException

@synthesize requestError = _requestError;

+(TSKRequestException*)exceptionWithError:(NSError*)error;
{
    TSKRequestException *exc = [[self alloc]
                                         initWithName:NSLocalizedString(@"HTTP error", @"HTTP error")
                                         reason:error.description userInfo:nil];
    
    exc.requestError = error;
    
    return exc;
}


@end
