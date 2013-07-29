//
//  TSKFirstViewController.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKAuthorInfoViewController.h"
#import "TSKAppDelegate.h"
#import "Person.h"
#import "Phone.h"
#import "Email.h"
#import "Messenger.h"
#import <CoreData/CoreData.h>
#import "TSKAppDelegate.h"

@interface TSKAuthorInfoViewController ()

@property(nonatomic, strong) NSManagedObjectContext *dataContext;
@property(nonatomic, strong) Person *me;
@property(nonatomic, strong) NSArray *phones;
@property(nonatomic, strong) NSArray *emails;
@property(nonatomic, strong) NSArray *messengers;

@end

@implementation TSKAuthorInfoViewController

@synthesize dataContext = _dataContext;
@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize bioView = _bioView;
@synthesize me = _me;
@synthesize phones = _phones;
@synthesize emails = _emails;
@synthesize messengers = _messengers;
@synthesize infoView = _infoView;
@synthesize contentView = _contentView;

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
        self.phones = [self.me.phones allObjects];
        self.emails = [self.me.emails allObjects];
        self.messengers = [self.me.messengers allObjects];
   }
    
    Person *me = self.me;
    
    self.photoView.image = [UIImage imageWithData:me.photo];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", me.name, me.surname];
    self.bioView.text = me.bio;
    
    [self.contentView reloadData];
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
            return nil;
    }
}

-(CGFloat)infoHeight
{
    CGRect bioFrame = self.bioView.frame;
    NSString *bio = self.me.bio;
    
    UIFont *bioFont = self.bioView.font;
    CGFloat letterSize = bioFont.xHeight * 2;
    CGFloat bioWidth = bioFrame.size.width;
    CGFloat bioHeight = letterSize * (bio.length * letterSize / bioWidth);
    
    return bioFrame.origin.y + bioHeight + 20;
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
        case 0:
        {
            CGRect infoFrame = self.infoView.frame;
            infoFrame.size.height = [self infoHeight];
            infoFrame.origin.y = 10;
            
            UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            if (!infoCell)
            {
                infoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"InfoCell"];
                [infoCell.contentView addSubview:self.infoView];
                self.infoView.frame = infoFrame;
            }
            
            return infoCell;
        }
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

-(CGFloat)tableView:(UITableView*)tView heightForRowAtIndexPath:(NSIndexPath*)path
{
    if (0 == path.section)
    {
        return [self infoHeight] + 20;
    }
    
    return 44;
}

@end
