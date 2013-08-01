//
//  TSKFirstViewController.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKUserViewController.h"
#import "TSKAppDelegate.h"
#import "Person.h"
#import "Phone.h"
#import "Email.h"
#import "Messenger.h"
#import <CoreData/CoreData.h>
#import "TSKAppDelegate.h"
#import "TSKFBAccount.h"
#import "TSKLoadQueueManager.h"
#import "TSKDataEditorViewController.h"
#import "TSKPersonStore.h"

@interface TSKUserViewController ()<TSKDataEditorDelegate>
{
    BOOL _isLoading;
}

@property(nonatomic, strong) Person *me;

@property(nonatomic, strong) TSKPersonStore *userStore;

@end

@implementation TSKUserViewController

@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize birthdayLabel = _birthdayLabel;
@synthesize me = _me;
@synthesize logoutBtn = _logoutBtn;
@synthesize birthCaption = _birthCaption;
@synthesize userStore = _userStore;
@synthesize editButton = _editButton;

-(void)updateUI
{
    NSLog(@"%@", @"UI update");
    Person *me = self.me;
    
    self.photoView.image = me ? [UIImage imageWithData:me.photo] : nil;
    self.nameLabel.text = me ? [NSString stringWithFormat:@"%@ %@", me.name, me.surname] : @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    self.birthdayLabel.text = me ? [formatter stringFromDate:me.birthDate] : @"";
    
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.logoutBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    if (FBSessionStateOpen == appDelegate.fbSession.state)
    {
        [self.logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.logoutBtn setTitle:@"Log In" forState:UIControlStateNormal];
        [self.logoutBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.birthCaption.hidden = (nil == me);
    
    self.editButton.enabled = (nil != me);
    self.editButton.hidden = (nil == me);
    
    [self.view setNeedsDisplay];
}

-(void)addFacebookAccount:(id)data
{
    NSManagedObjectContext *dataContext = self.userStore.dataContext;
    NSEntityDescription *personDesc = [NSEntityDescription
                                       entityForName:@"Person" inManagedObjectContext:dataContext];
    Person *me = [[Person alloc] initWithEntity:personDesc insertIntoManagedObjectContext:dataContext];
    me.name = [data objectForKey:@"first_name"];
    me.surname = [data objectForKey:@"last_name"];
    
    NSDateFormatter *dateParser = [NSDateFormatter new];
    [dateParser setDateFormat:@"MM/dd/yyyy"];
    me.birthDate = [dateParser dateFromString:[data objectForKey:@"birthday"]];
    me.photo = [data objectForKey:@"avatar"];
    
    NSEntityDescription *emailDesc = [NSEntityDescription
                                      entityForName:@"Email" inManagedObjectContext:dataContext];
    Email *email = [[Email alloc] initWithEntity:emailDesc insertIntoManagedObjectContext:dataContext];
    email.address = [data objectForKey:@"email"];
    email.info = @"Email from Facebook";
    
    me.emails = [NSSet setWithObject:email];
    
    [dataContext save:NULL];
    
    self.me = me;
    [self updateUI];
    
    _isLoading = NO;
}

-(void)getData
{
    _isLoading = YES;
    
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    TSKFBAccount *acc = appDelegate.fbAccount;
    
    TSKLoadTransaction getMe = [TSKLoadQueueManager exceptionHandleDecoratedTransaction:^{
            id myData = [acc profile];
            
            [self performSelectorOnMainThread:@selector(addFacebookAccount:)
                                   withObject:myData waitUntilDone:YES];
    }];
        
    [TSKLoadQueueManager scheduleTransaction:getMe];
}

-(void)getDataIfNeeded
{
    if (_isLoading) return;
    
    NSFetchRequest *personGetter = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSError *err = nil;
    NSArray *personArray = [self.userStore.dataContext executeFetchRequest:personGetter error:&err];
    
    if (!personArray.count)
    {
        [self getData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userStore = [TSKPersonStore userStore];
    
    NSFetchRequest *personGetter = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSError *err = nil;
    NSArray *personArray = [self.userStore.dataContext executeFetchRequest:personGetter error:&err];
    
    if (personArray.count)
    {
        self.me = [personArray objectAtIndex:0];
        [self updateUI];
    }
    else
    {
        [self getDataIfNeeded];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)logout:(id)sender
{
    Person *me = self.me;
    [me removeAll];
    self.me = nil;
    
    [self.userStore.dataContext save:NULL];

    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate logout];

    [self updateUI];
}

-(IBAction)editData:(id)sender
{
    TSKDataEditorViewController *editor = [[TSKDataEditorViewController alloc] init];
    editor.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    editor.user = self.me;
    editor.dataContext = self.userStore.dataContext;
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:NULL];
}

-(IBAction)login:(id)sender
{
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate authenticate];
}

-(void)dataSaved
{
    [self updateUI];
}

@end
