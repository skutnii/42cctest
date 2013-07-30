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

-(NSString*)cachePath
{
    TSKAppDelegate *appDelegate = (TSKAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *docsDir = [appDelegate appDocumentsDirectory];
    
    NSString *cacheDir = [docsDir stringByAppendingPathComponent:@"__friends_data_cache__"];
    NSFileManager *fManager = [NSFileManager defaultManager];
    if (![fManager fileExistsAtPath:cacheDir])
    {
        [fManager createDirectoryAtPath:cacheDir withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    return cacheDir;
}

-(NSString*)cachePathForLink:(NSString*)link
{
    NSString *cachePath = [self cachePath];
    NSString *fName = [link lastPathComponent];
    NSString *cachedObjectPath = [cachePath stringByAppendingPathComponent:fName];
    
    return cachedObjectPath;
}

-(NSData*)cachedDataForLink:(NSString*)link
{
    NSString *cachedObjectPath = [self cachePathForLink:link];
    
    return [NSData dataWithContentsOfFile:cachedObjectPath];
}

-(void)cacheData:(NSData*)data forLink:(NSString*)link
{
    NSString *cachedObjectPath = [self cachePathForLink:link];
    [data writeToFile:cachedObjectPath atomically:YES];
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
            NSDictionary *friend = [self.friends objectAtIndex:i];
            NSString *avaLink = [[[friend objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
            NSURL *avaUrl = [NSURL URLWithString:avaLink];
            NSData *avaData = [NSData dataWithContentsOfURL:avaUrl];
            [self cacheData:avaData forLink:avaLink];
            
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
    
    NSDictionary *aFriend = [self.friends objectAtIndex:indexPath.row];
    NSString *link = [[[aFriend objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    
    cell.textLabel.text = [aFriend objectForKey:@"name"];
    NSData *avaData = [self cachedDataForLink:link];
    if (avaData)
    {
        cell.imageView.image = [UIImage imageWithData:avaData];
    }
    else
    {
        cell.imageView.image = nil;
    }
    
    return cell;
}

@end
