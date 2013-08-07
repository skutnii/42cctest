//
//  Person.h
//  Test
//
//  Created by Serge Kutny on 7/2/13.
//  Copyright (c) 2013 42coffeecups. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Email, Messenger, Phone;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *messengers;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addPhonesObject:(Phone *)value;
- (void)removePhonesObject:(Phone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addMessengersObject:(Messenger *)value;
- (void)removeMessengersObject:(Messenger *)value;
- (void)addMessengers:(NSSet *)values;
- (void)removeMessengers:(NSSet *)values;

-(void)removeAll;

@end
