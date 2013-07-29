//
//  TSKPersonStore.m
//  Test
//
//  Created by Serge Kutny on 7/30/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKPersonStore.h"
#import "TSKAppDelegate.h"

@interface TSKPersonStore ()
{
    NSManagedObjectContext *_dataContext;
    NSManagedObjectModel *_dataModel;
    NSPersistentStoreCoordinator *_storeManager;
    NSPersistentStore *_dataStore;
    
    NSString *_storeName;
}

@end

@implementation TSKPersonStore

-(NSManagedObjectContext*)dataContext
{
    if (!_dataContext)
    {
        _dataContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        _dataContext.persistentStoreCoordinator = self.storeManager;
    }
    
    return _dataContext;
}

-(NSManagedObjectModel*)dataModel
{
    if (!_dataModel)
    {
        _dataModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _dataModel;
}

-(NSPersistentStoreCoordinator*)storeManager
{
    if (!_storeManager)
    {
        _storeManager = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.dataModel];
        
        NSString *docsDir = [(TSKAppDelegate*)[UIApplication sharedApplication].delegate appDocumentsDirectory];
        NSString *storePath = [docsDir stringByAppendingPathComponent:_storeName];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        NSPersistentStore *aStore = [_storeManager persistentStoreForURL:storeURL];
        if (!aStore)
        {
            NSError *err = nil;
            aStore = [_storeManager
                      addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                      URL:storeURL options:nil error:&err];
            if (err)
            {
                NSLog(@"%@", [err description]);
            }
        }
    }
    
    return _storeManager;
}

-(NSPersistentStore*)dataStore
{
    if (!_dataStore)
    {
        NSString *docsDir = [(TSKAppDelegate*)[UIApplication sharedApplication].delegate appDocumentsDirectory];
        NSString *storePath = [docsDir stringByAppendingPathComponent:_storeName];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        _dataStore = [self.storeManager persistentStoreForURL:storeURL];
    }
    
    return _dataStore;
}

-(id)initWithStoreFileName:(NSString*)fileName
{
    if (self = [super init])
    {
        _storeName = [fileName copy];
    }
    
    return self;
}

@end
