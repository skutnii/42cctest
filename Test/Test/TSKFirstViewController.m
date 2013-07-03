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

@interface TSKFirstViewController ()

@property(nonatomic, strong) NSManagedObjectContext *dataContext;
@property(nonatomic, strong) Person *me;

@end

@implementation TSKFirstViewController

@synthesize dataContext = _dataContext;
@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize bioView = _bioView;
@synthesize me = _me;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
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
    }
    
    Person *me = self.me;
    
    self.photoView.image = [UIImage imageWithData:me.photo];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", me.name, me.surname];
    self.bioView.text = me.bio;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
