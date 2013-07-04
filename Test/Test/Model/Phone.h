//
//  Phone.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Phone : NSManagedObject

@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) Person *owner;

@end
