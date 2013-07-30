//
//  TSKFriendsViewController.h
//  Test
//
//  Created by Serge Kutny on 7/31/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSKFriendsViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITableView *friendsListView;
@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

@end
