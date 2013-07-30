//
//  TSKFirstViewController.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSKUserViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UIImageView *photoView;
@property(nonatomic, strong) IBOutlet UILabel *birthdayLabel;
@property(nonatomic, strong) IBOutlet UIButton *logoutBtn;
@property(nonatomic, strong) IBOutlet UIButton *editButton;
@property(nonatomic, strong) IBOutlet UILabel *birthCaption;

-(IBAction)logout:(id)sender;
-(IBAction)editData:(id)sender;
-(IBAction)login:(id)sender;

-(void)getDataIfNeeded;

@end
