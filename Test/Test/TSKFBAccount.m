//
//  TSKFBAccount.m
//  Test
//
//  Created by Serge Kutny on 7/8/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKFBAccount.h"
#import "SKCallExecutor.h"
#import "TSKFriend.h"

extern NSString * const kFBAppID;

@interface TSKFBAccount ()

@property(strong, nonatomic) FBSession *session;

@end

@implementation TSKFBAccount

-(id)initWithSession:(FBSession*)session
{
    if (self = [super init])
    {
        self.session = session;
    }
    
    return self;
}

-(id)dataForFBRequest:(FBRequest*)fbrq
{
    FBRequestConnection *conn = [[FBRequestConnection alloc] init];
    [conn addRequest:fbrq completionHandler:NULL];
    NSURLRequest *realRq = conn.urlRequest;
    
    SKCallExecutor *executor = [SKCallExecutor defaultJSONExecutor];
    executor.loader = [SKCallExecutor dataLoaderForRequest:realRq];
    
    return executor.execute;
}

-(id)profile
{
    FBSession *session = self.session;
    FBRequest *meGetter = [FBRequest requestForMe];
    meGetter.session = session;
    
    NSMutableDictionary *myData = [[self dataForFBRequest:meGetter] mutableCopy];
    
    FBRequest *picGetter = [FBRequest requestForGraphPath:@"me/picture"];
    picGetter.session = session;
    FBRequestConnection *conn = [[FBRequestConnection alloc] init];
    [conn addRequest:picGetter completionHandler:NULL];
    NSURLRequest *picRq = conn.urlRequest;
    
    NSData *avaData = [NSURLConnection sendSynchronousRequest:picRq returningResponse:NULL error:NULL];
    
    [myData setObject:avaData forKey:@"avatar"];
    
    return myData;
}

-(NSArray*)friends
{
    FBRequest *friendsGetter = [FBRequest requestForGraphPath:@"me/friends"];
    [friendsGetter.parameters
     setObject:@"id,name,picture,first_name,last_name,link" forKey:@"fields"];
    friendsGetter.session = self.session;
    
    NSDictionary *data = [self dataForFBRequest:friendsGetter];
    NSArray *rawFriends = [data objectForKey:@"data"];
    
    NSMutableArray *realFriends = [NSMutableArray arrayWithCapacity:rawFriends.count];
    for (NSDictionary *entry in rawFriends)
    {
        TSKFriend *friend = [[TSKFriend alloc] initWithDataEntry:entry];
        [realFriends addObject:friend];
    }
    
    return realFriends;
}

@end
