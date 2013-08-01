//
//  TSKFriend.m
//  Test
//
//  Created by Serge Kutny on 8/1/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKFriend.h"
#import "TSKAppDelegate.h"

@implementation TSKFriend

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize avatarLink = _avatarLink;

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

-(void)cacheAvatarData:(NSData*)data
{
    NSString *cachedObjectPath = [self cachePathForLink:self.avatarLink];
    [data writeToFile:cachedObjectPath atomically:YES];
}

-(UIImage*)cachedAvatar
{
    NSString *cachedObjectPath = [self cachePathForLink:self.avatarLink];
    
    NSData *avaData = [NSData dataWithContentsOfFile:cachedObjectPath];
    if (!avaData) return nil;
    
    return [UIImage imageWithData:avaData];
}

-(id)initWithDataEntry:(NSDictionary*)entry
{
    if (self = [super init])
    {
        self.firstName = [entry objectForKey:@"first_name"];
        self.lastName = [entry objectForKey:@"last_name"];
        self.avatarLink = [[[entry objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    }
    
    return self;
}

@end
