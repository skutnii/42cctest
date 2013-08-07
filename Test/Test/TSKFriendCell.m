//
//  TSKFriendCell.m
//  Test
//
//  Created by Serge Kutny on 8/1/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKFriendCell.h"
#import "TSKFriend.h"
#import "TSKFriendsViewController.h"

@interface TSKFriendsViewController ()

-(void)prioritizeFriend:(TSKFriend*)friend;

@end

@implementation TSKFriendCell

@synthesize aFriend = _aFriend;
@synthesize owner = _owner;

-(void)prioritize:(id)sender
{
    [self.owner prioritizeFriend:self.aFriend];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIButton *priorityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *shuffle = [UIImage imageNamed:@"shuffle.png"];
        [priorityButton setImage:shuffle forState:UIControlStateNormal];
        priorityButton.frame = CGRectMake(0, 0, shuffle.size.width, shuffle.size.height);
        
        [priorityButton addTarget:self action:@selector(prioritize:) forControlEvents:UIControlEventTouchUpInside];
        
        self.accessoryView = priorityButton;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
