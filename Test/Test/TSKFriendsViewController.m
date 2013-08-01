//
//  TSKFriendsViewController.m
//  Test
//
//  Created by Serge Kutny on 7/31/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKFriendsViewController.h"
#import "TSKAppDelegate.h"
#import "TSKFBAccount.h"
#import "TSKLoadQueueManager.h"
#import "TSKFriend.h"

@interface TSKFriendsViewController ()

@property(nonatomic, strong) NSArray *friends;

-(void)getFriends;

@end

@implementation TSKFriendsViewController

@synthesize friendsListView = _friendsListView;
@synthesize friends = _friends;
@synthesize spinner = _spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getFriends];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:) name:kLoginStateChangeNotification object:nil];
}

-(void)loginStateChange:(NSNotification*)n
{
    self.friends = nil;
    [self.friendsListView reloadData];
    
    [self getFriends];
}

-(void)reloadIndexPath:(NSIndexPath*)iPath
{
    [self.friendsListView
     reloadRowsAtIndexPaths:[NSArray arrayWithObject:iPath]
     withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didLoadFriends
{
    [self.spinner stopAnimating];
    [self.friendsListView reloadData];
}

-(void)getFriends
{
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appDelegate.fbSession) return;
    
    TSKFBAccount *acc = appDelegate.fbAccount;
    
    [self.spinner startAnimating];
    
    TSKLoadTransaction getFriends = [TSKLoadQueueManager exceptionHandleDecoratedTransaction:^{
        
        self.friends = [acc friends];
        
        [self performSelectorOnMainThread:@selector(didLoadFriends)
                               withObject:nil waitUntilDone:YES];
        
        for (unsigned int i = 0; i < self.friends.count; ++i)
        {
            TSKFriend *friend = [self.friends objectAtIndex:i];
            NSURL *avaUrl = [NSURL URLWithString:friend.avatarLink];
            NSData *avaData = [NSData dataWithContentsOfURL:avaUrl];
            [friend cacheAvatarData:avaData];
            
            NSIndexPath *reloadPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self
             performSelectorOnMainThread:@selector(reloadIndexPath:)
             withObject:reloadPath waitUntilDone:NO];
        }
    }];
    
    [TSKLoadQueueManager scheduleTransaction:getFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view management

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tView
{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

-(UITableViewCell*)tableView:(UITableView*)tView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.friendsListView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    TSKFriend *aFriend = [self.friends objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", aFriend.firstName, aFriend.lastName];
    cell.imageView.image = aFriend.cachedAvatar;
    
    return cell;
}

@end
