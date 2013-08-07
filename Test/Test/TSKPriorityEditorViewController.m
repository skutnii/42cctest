//
//  TSKPriorityEditorViewController.m
//  Test
//
//  Created by Serge Kutny on 8/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKPriorityEditorViewController.h"
#import "TSKFriend.h"
#import "TSKFriendsViewController.h"

@interface TSKFriendsViewController ()

-(void)didPrioritizeFriend:(TSKFriend *)friend;

@end

@interface TSKPriorityEditorViewController ()

@end

@implementation TSKPriorityEditorViewController

@synthesize priorityInput = _priorityInput;
@synthesize avatarView = _avatarView;
@synthesize nameLabel = _nameLabel;

@synthesize owner = _owner;
@synthesize aFriend = _aFriend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.priorityInput.text = [NSString stringWithFormat:@"%i", self.aFriend.priority];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.aFriend.firstName, self.aFriend.lastName];
    self.avatarView.image = self.aFriend.cachedAvatar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender
{
    self.aFriend.priority = [self.priorityInput.text integerValue];
    
    [self.owner didPrioritizeFriend:self.aFriend];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)isValidString:(NSString*)string
{
    NSCharacterSet *illegal = [NSCharacterSet
                               characterSetWithCharactersInString:@",.-"];
    return (NSNotFound == [string rangeOfCharacterFromSet:illegal].location);
}


-(BOOL)textField:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self isValidString:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
