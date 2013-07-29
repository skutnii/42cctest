//
//  TSKPersonStore.h
//  Test
//
//  Created by Serge Kutny on 7/30/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TSKPersonStore : NSObject

@property(nonatomic, readonly) NSManagedObjectContext *dataContext;
@property(nonatomic, readonly) NSManagedObjectModel *dataModel;
@property(nonatomic, readonly) NSPersistentStoreCoordinator *storeManager;
@property(nonatomic, readonly) NSPersistentStore *dataStore;

-(id)initWithStoreFileName:(NSString*)fileName;

@end
