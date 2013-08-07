//
//  TSKRequestException.h
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSKRequestException : NSException

@property(strong, nonatomic) NSError *requestError;

+(TSKRequestException*)exceptionWithError:(NSError*)err;

@end
