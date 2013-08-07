//
//  TSKPriorityEditorViewController.h
//  Test
//
//  Created by Serge Kutny on 8/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSKFriendsViewController;
@class TSKFriend;

@interface TSKPriorityEditorViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITextField *priorityInput;
@property(nonatomic, strong) IBOutlet UIImageView *avatarView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;

@property(nonatomic, weak) TSKFriendsViewController *owner;
@property(nonatomic, strong) TSKFriend *aFriend;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;

@end
