//
//  TSKDataEditorViewController.h
//  Test
//
//  Created by Serge Kutny on 7/13/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@protocol TSKDataEditorDelegate <NSObject>

-(void)dataSaved;

@end

@interface TSKDataEditorViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) Person *user;
@property(nonatomic, strong) NSManagedObjectContext *dataContext;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;

@property(nonatomic, strong) IBOutlet UIButton *saveButton;
@property(nonatomic, strong) IBOutlet UIDatePicker *birthdayPicker;
@property(nonatomic, strong) IBOutlet UITextField *firstNameInput;
@property(nonatomic, strong) IBOutlet UITextField *lastNameInput;

@property(nonatomic, weak) id<TSKDataEditorDelegate> delegate;

@end
