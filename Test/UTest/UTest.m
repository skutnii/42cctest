//
//  UTest.m
//  UTest
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "UTest.h"
#import "TSKAppDelegate.h"
#import "TSKAuthorInfoViewController.h"

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

-(void)testAuthorInfoNib
{
    TSKAuthorInfoViewController *infoViewer = [[TSKAuthorInfoViewController alloc] init];
    
    STAssertTrue([infoViewer.view isKindOfClass:[UIView class]], @"Invalid view object");
    STAssertTrue([infoViewer.contentView isKindOfClass:[UITableView class]], @"Invalid contentView");
    STAssertEquals(infoViewer.contentView.superview, infoViewer.view, @"contentView not in view hierarchy");
    STAssertEquals(infoViewer.contentView.dataSource, infoViewer, @"contentView.dataSource is not set to controller");
    STAssertEquals(infoViewer.contentView.delegate, infoViewer, @"contentView.delegate is not set to controller");
    
    STAssertTrue([infoViewer.infoView isKindOfClass:[UIView class]], @"Invalid infoView object");
    
    STAssertTrue([infoViewer.nameLabel isKindOfClass:[UILabel class]], @"Invalid namelabel object");
    STAssertEquals(infoViewer.nameLabel.superview, infoViewer.infoView, @"nameLabel not a subview of infoView");
    
    STAssertTrue([infoViewer.photoView isKindOfClass:[UIImageView class]], @"Invalid photoView");
    STAssertEquals(infoViewer.photoView.superview, infoViewer.infoView, @"photoView not a subview of infoView");
    
    STAssertTrue([infoViewer.bioView isKindOfClass:[UITextView class]], @"Invalid bioView");
    STAssertEquals(infoViewer.bioView.superview, infoViewer.infoView, @"ioView not a subview of infoView");
}

@end
