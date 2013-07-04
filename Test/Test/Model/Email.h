//
//  Email.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Email : NSManagedObject

@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSManagedObject *owner;

@end
