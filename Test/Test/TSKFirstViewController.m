//
//  TSKFirstViewController.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKFirstViewController.h"
#import "TSKAppDelegate.h"
#import "Person.h"
#import "Phone.h"
#import "Email.h"
#import "Messenger.h"
#import <CoreData/CoreData.h>
#import "TSKAppDelegate.h"
#import "TSKFBAccount.h"
#import "TSKLoadQueueManager.h"

@interface TSKFirstViewController ()

@property(nonatomic, strong) NSManagedObjectContext *dataContext;
@property(nonatomic, strong) Person *me;

@end

@implementation TSKFirstViewController

@synthesize dataContext = _dataContext;
@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize birthdayLabel = _birthdayLabel;
@synthesize me = _me;
@synthesize logoutBtn = _logoutBtn;
@synthesize birthCaption = _birthCaption;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

-(void)updateUI
{
    NSLog(@"%@", @"UI update");
    Person *me = self.me;
    
    self.photoView.image = me ? [UIImage imageWithData:me.photo] : nil;
    self.nameLabel.text = me ? [NSString stringWithFormat:@"%@ %@", me.name, me.surname] : @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    self.birthdayLabel.text = me ? [formatter stringFromDate:me.birthDate] : @"";
    
    self.logoutBtn.enabled = (nil != me);
    self.logoutBtn.hidden = (nil == me);
    self.birthCaption.hidden = (nil == me);
    
    [self.view setNeedsDisplay];
}

-(void)addFacebookAccount:(id)data
{
    NSEntityDescription *personDesc = [NSEntityDescription
                                       entityForName:@"Person" inManagedObjectContext:self.dataContext];
    Person *me = [[Person alloc] initWithEntity:personDesc insertIntoManagedObjectContext:self.dataContext];
    me.name = [data objectForKey:@"first_name"];
    me.surname = [data objectForKey:@"last_name"];
    
    NSDateFormatter *dateParser = [NSDateFormatter new];
    [dateParser setDateFormat:@"MM/dd/yyyy"];
    me.birthDate = [dateParser dateFromString:[data objectForKey:@"birthday"]];
    me.photo = [data objectForKey:@"avatar"];
    
    NSEntityDescription *emailDesc = [NSEntityDescription
                                      entityForName:@"Email" inManagedObjectContext:self.dataContext];
    Email *email = [[Email alloc] initWithEntity:emailDesc insertIntoManagedObjectContext:self.dataContext];
    email.address = [data objectForKey:@"email"];
    email.info = @"Email from Facebook";
    
    me.emails = [NSSet setWithObject:email];
    
    [self.dataContext save:NULL];
    
    self.me = me;
    [self updateUI];
}

-(void)getData
{
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    TSKFBAccount *acc = appDelegate.fbAccount;
    
    TSKLoadTransaction getMe = [TSKLoadQueueManager exceptionHandleDecoratedTransaction:^{
            id myData = [acc profile];
            
            [self performSelectorOnMainThread:@selector(addFacebookAccount:)
                                   withObject:myData waitUntilDone:YES];
    }];
        
    [TSKLoadQueueManager scheduleTransaction:getMe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    self.dataContext = appDelegate.dataContext;
    
    NSFetchRequest *personGetter = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSError *err = nil;
    NSArray *personArray = [self.dataContext executeFetchRequest:personGetter error:&err];
    
    if (personArray.count)
    {
        self.me = [personArray objectAtIndex:0];
        [self updateUI];
    }
    else
    {
        [self getData];
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
    
    [self.dataContext save:NULL];

    [self updateUI];

    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate performSelector:@selector(logout) withObject:nil afterDelay:0.25];
}

@end
