//
//  Person.m
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import "Person.h"
#import "Email.h"
#import "Messenger.h"
#import "Phone.h"


@implementation Person

@dynamic photo;
@dynamic name;
@dynamic surname;
@dynamic birthDate;
@dynamic bio;
@dynamic emails;
@dynamic phones;
@dynamic messengers;

-(void)removeAll
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSSet *emails = self.emails;
    [self removeEmails:emails];
    for (Email *email in emails)
    {
        [context deleteObject:email];
    }
    
    NSSet *phones = self.phones;
    [self removePhones:phones];
    for (Phone *phone in phones)
    {
        [context deleteObject:phone];
    }
    
    NSSet *messengers = self.messengers;
    [self removeMessengers:messengers];
    for (Messenger *messenger in messengers)
    {
        [context deleteObject:messenger];
    }
    
    [context deleteObject:self];
}

@end
