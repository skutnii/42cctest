//
//  TSKFriend.h
//  Test
//
//  Created by Serge Kutny on 8/1/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSKFriend : NSObject

@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, copy) NSString *avatarLink;
@property(nonatomic, copy) NSString *identity;

@property(nonatomic, readonly) UIImage *cachedAvatar;

@property(nonatomic, assign) NSUInteger priority;

-(void)cacheAvatarData:(NSData*)data;

-(id)initWithDataEntry:(NSDictionary*)entry;

@end
