//
//  TSKFriendCell.h
//  Test
//
//  Created by Serge Kutny on 8/1/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSKFriend;
@class TSKFriendsViewController;

@interface TSKFriendCell : UITableViewCell

@property(nonatomic, strong) TSKFriend *aFriend;
@property(nonatomic, weak) TSKFriendsViewController *owner;

@end
