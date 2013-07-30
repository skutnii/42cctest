//
//  TSKDataEditorViewController.m
//  Test
//
//  Created by Serge Kutny on 7/13/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "TSKDataEditorViewController.h"
#import "Person.h"

@interface TSKDataEditorViewController ()

-(void)validateSaveForTextField:(UITextField*)textField
  shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

@implementation TSKDataEditorViewController

@synthesize saveButton = _saveButton;
@synthesize user = _user;
@synthesize birthdayPicker = _birthdayPicker;
@synthesize firstNameInput = _firstNameInput;
@synthesize lastNameInput = _lastNameInput;
@synthesize delegate = _delegate;

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
    self.birthdayPicker.maximumDate = [NSDate date];
    self.birthdayPicker.date = self.user.birthDate;
    
    self.firstNameInput.text = self.user.name;
    self.lastNameInput.text = self.user.surname;
    
    [self validateSaveForTextField:nil shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender
{
    self.user.name = self.firstNameInput.text;
    self.user.surname = self.lastNameInput.text;
    self.user.birthDate = self.birthdayPicker.date;
    
    [self.dataContext save:NULL];
    
    [self.delegate dataSaved];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)isValidString:(NSString*)string
{
    NSCharacterSet *illegal = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789.±!@#$%^&*()_+-`\[]{}|\";:,/~<>"];
    return (string.length > 0) && (NSNotFound == [string rangeOfCharacterFromSet:illegal].location);
}

-(void)validateSaveForTextField:(UITextField*)textField
   shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL enableSave = YES;
    
    if (textField != self.firstNameInput)
    {
        enableSave = enableSave && [self isValidString:self.firstNameInput.text];
    }
    
    if (textField != self.lastNameInput)
    {
        enableSave = enableSave && [self isValidString:self.lastNameInput.text];
    }
    
    if (textField)
    {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        enableSave = enableSave && [self isValidString:newText];
    }
    
    self.saveButton.enabled = enableSave;
}

-(BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self validateSaveForTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end