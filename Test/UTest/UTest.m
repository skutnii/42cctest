//
//  UTest.m
//  UTest
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "UTest.h"
#import "TSKAppDelegate.h"

@interface TSKAppDelegate ()

-(NSString*)appDocumentsDirectory;

@end

@implementation UTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#if 0
- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in UTest");
}
#endif

-(void)testCoreDataStack
{
    TSKAppDelegate *delegate = [[TSKAppDelegate alloc] init];
    
    STAssertNotNil(delegate.dataModel, @"Could not load the application data model");
    STAssertNotNil(delegate.storeManager, @"Could not create persistent store coordinator");
    STAssertNotNil([delegate appDocumentsDirectory], @"No documents directory found");
    
    STAssertNotNil(delegate.dataStore, @"Could not load or create data store");
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:delegate.dataStore.URL.path],
                 @"Persistent store file missing");
    
    NSLog(@"%@", @"Model loading succeeded");
}

@end
