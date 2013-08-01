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
#import "TSKPersonStore.h"
#import "TSKDataEditorViewController.h"

@implementation UTest

#pragma mark Helpers

-(void)validatePersonStore:(TSKPersonStore*)store
{
    STAssertNotNil(store.dataModel, @"Could not load the application data model");
    STAssertNotNil(store.storeManager, @"Could not create persistent store coordinator");
    
    STAssertNotNil(store.dataStore, @"Could not load or create data store");
    STAssertTrue([[NSFileManager defaultManager]
                  fileExistsAtPath:store.dataStore.URL.path], @"Persistent store file missing");
}

#pragma mark -

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

-(void)testDocumentsDirectory
{
    TSKAppDelegate *delegate = [[TSKAppDelegate alloc] init];
    STAssertNotNil([delegate appDocumentsDirectory], @"No documents directory for the application");
}

-(void)testUserCoreDataStack
{
    TSKPersonStore *userStore = [TSKPersonStore userStore];
    [self validatePersonStore:userStore];
}

-(void)testAuthorCoreDataStack
{
    TSKPersonStore *authorStore = [TSKPersonStore authorStore];
    [self validatePersonStore:authorStore];
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
    STAssertEquals(infoViewer.bioView.superview, infoViewer.infoView, @"bioView not a subview of infoView");
}

-(void)testDataEditorEmptyFieldsValidation
{
    TSKDataEditorViewController *editor = [[TSKDataEditorViewController alloc] init];
    
    UITextField *firstNameInput = [[UITextField alloc] init];
    firstNameInput.text = @"A";
    editor.firstNameInput = firstNameInput;
    
    UITextField *lastNameInput = [[UITextField alloc] init];
    lastNameInput.text = @"B";
    editor.lastNameInput = lastNameInput;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.enabled = YES;
    editor.saveButton = saveButton;
    
    NSRange replacementRange = NSMakeRange(0, 1);
    
    [editor textField:firstNameInput
        shouldChangeCharactersInRange:replacementRange replacementString:@""];
    STAssertFalse(saveButton.enabled, @"Save should be disabled when firstNameInput is empty");
    
    saveButton.enabled = YES;

    [editor textField:lastNameInput
        shouldChangeCharactersInRange:replacementRange replacementString:@""];
    STAssertFalse(saveButton.enabled, @"Save should be disabled when lastNameInput is empty");

    saveButton.enabled = YES;

    [editor textField:firstNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"a"];
    STAssertTrue(saveButton.enabled, @"Save should be enabled when both inputs are not empty");

    saveButton.enabled = YES;
    
    [editor textField:lastNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"b"];
    STAssertTrue(saveButton.enabled, @"Save should be enabled when both inputs are not empty");
    
    saveButton.enabled = YES;
    
    firstNameInput.text = @"";
    [editor textField:firstNameInput
        shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"A"];
    STAssertTrue(saveButton.enabled, @"Save should be enabled when firstNameInput is not empty");
    
    firstNameInput.text = @"A";
    saveButton.enabled = YES;

    lastNameInput.text = @"";
    [editor textField:lastNameInput
        shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"B"];
    STAssertTrue(saveButton.enabled, @"Save should be enabled when lastNameInput is not empty");
}

-(void)testDataEditorInvalidCharactersValidation
{
    TSKDataEditorViewController *editor = [[TSKDataEditorViewController alloc] init];
    
    UITextField *firstNameInput = [[UITextField alloc] init];
    firstNameInput.text = @"A";
    editor.firstNameInput = firstNameInput;
    
    UITextField *lastNameInput = [[UITextField alloc] init];
    lastNameInput.text = @"B";
    editor.lastNameInput = lastNameInput;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.enabled = YES;
    editor.saveButton = saveButton;
    
    STAssertFalse([editor textField:firstNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"#"], @"Entering invalid characters in firstNameInput should not be allowed");

    STAssertFalse([editor textField:lastNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"1"], @"Entering invalid characters in lastNameInput should not be allowed");
    
    STAssertTrue([editor textField:firstNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"a"], @"Entering valid characters in firstNameInput should be allowed");

    STAssertTrue([editor textField:lastNameInput shouldChangeCharactersInRange:NSMakeRange(1,0) replacementString:@"t"], @"Entering valid characters in lastNameInput should be allowed");
}

@end
