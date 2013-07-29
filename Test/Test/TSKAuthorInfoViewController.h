//
//  TSKFirstViewController.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSKAuthorInfoViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UIImageView *photoView;
@property(nonatomic, strong) IBOutlet UITextView *bioView;
@property(nonatomic, strong) IBOutlet UIView *infoView;

@property(nonatomic, strong) IBOutlet UITableView *contentView;

@end