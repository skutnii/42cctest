//
//  TSKSecondViewController.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKSecondViewController.h"
#import "Person.h"
#import "Phone.h"
#import "Email.h"
#import "Messenger.h"
#import <CoreData/CoreData.h>
#import "TSKAppDelegate.h"

@interface TSKSecondViewController ()

@property(nonatomic, strong) NSManagedObjectContext *dataContext;
@property(nonatomic, strong) Person *me;
@property(nonatomic, strong) NSArray *phones;
@property(nonatomic, strong) NSArray *emails;
@property(nonatomic, strong) NSArray *messengers;

@end

@implementation TSKSecondViewController

@synthesize contactsView = _contactsView;
@synthesize dataContext = _dataContext;
@synthesize me = _me;
@synthesize phones = _phones;
@synthesize emails = _emails;
@synthesize messengers = _messengers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    self.dataContext = appDelegate.dataContext;
    
    NSFetchRequest *personGetter = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSError *err = nil;
    NSArray *personArray = [self.dataContext executeFetchRequest:personGetter error:&err];
    
    if (personArray.count)
    {
        self.me = [personArray objectAtIndex:0];
        self.phones = [self.me.phones allObjects];
        self.emails = [self.me.emails allObjects];
        self.messengers = [self.me.messengers allObjects];
    }
    
    [self.contactsView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView management

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return self.me.phones.count;
        case 2:
            return self.me.emails.count;
        case 3:
            return self.me.messengers.count;
        default:
            return 0;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 1:
            return @"Phones";
        case 2:
            return @"Emails";
        case 3:
            return @"Messengers";
        default:
            return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!contactCell)
    {
        contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContactCell"];
    }
    
    switch (indexPath.section)
    {
        case 1:
        {
            Phone *phone = [self.phones objectAtIndex:indexPath.row];
            contactCell.textLabel.text = phone.number;
            contactCell.detailTextLabel.text = phone.info;
            break;
        }
        case 2:
        {
            Email *email = [self.emails objectAtIndex:indexPath.row];
            contactCell.textLabel.text = email.address;
            contactCell.detailTextLabel.text = email.info;
            break;
        }
        case 3:
        {
            Messenger *messenger = [self.messengers objectAtIndex:indexPath.row];
            contactCell.textLabel.text = messenger.nickname;
            contactCell.detailTextLabel.text = messenger.type;
        }
            
        default:
            break;
    }
    
    return  contactCell;
}

@end
